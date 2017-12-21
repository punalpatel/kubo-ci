package persistent_volume_test

import (
	"fmt"
	"math/rand"
	"strconv"

	"github.com/cloudfoundry/bosh-cli/director"
	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"

	"tests/config"
	. "tests/test_helpers"

	"github.com/onsi/gomega/gexec"
)

var _ = Describe("Guestbook storage", func() {

	var (
		deployment director.Deployment
		kubectl    *KubectlRunner
		testconfig *config.Config
	)

	BeforeSuite(func() {
		var err error
		testconfig, err = config.InitConfig()
		Expect(err).NotTo(HaveOccurred())
	})

	BeforeEach(func() {
		var err error
		director := NewDirector(testconfig.Bosh)
		deployment, err = director.FindDeployment(deploymentName)
		Expect(err).NotTo(HaveOccurred())

		kubectl = NewKubectlRunner(testconfig.Kubernetes.PathToKubeConfig)
		kubectl.CreateNamespace()

		storageClassSpec := PathFromRoot(fmt.Sprintf("specs/storage-class-%s.yml", iaas))
		Eventually(kubectl.RunKubectlCommand("create", "-f", storageClassSpec), "60s").Should(gexec.Exit(0))
		pvcSpec := PathFromRoot("specs/persistent-volume-claim.yml")
		Eventually(kubectl.RunKubectlCommand("create", "-f", pvcSpec), "60s").Should(gexec.Exit(0))

	})

	AfterEach(func() {
		UndeployGuestBook(kubectl)
		pvcSpec := PathFromRoot("specs/persistent-volume-claim.yml")
		Eventually(kubectl.RunKubectlCommand("delete", "-f", pvcSpec), "60s").Should(gexec.Exit(0))
		storageClassSpec := PathFromRoot(fmt.Sprintf("specs/storage-class-%s.yml", iaas))
		Eventually(kubectl.RunKubectlCommand("delete", "-f", storageClassSpec), "60s").Should(gexec.Exit(0))
		kubectl.RunKubectlCommand("delete", "namespace", kubectl.Namespace())
	})

	It("should persist when application was undeployed", func() {

		By("Deploying the persistent application the value is persisted")

		DeployGuestBook(kubectl)

		appAddress := kubectl.GetAppAddress(deployment, "svc/frontend")

		testValue := strconv.Itoa(rand.Int())
		println(testValue)

		PostToGuestBook(appAddress, testValue)

		Eventually(func() string {
			return GetValueFromGuestBook(appAddress)
		}, "120s", "2s").Should(ContainSubstring(testValue))

		By("Un-deploying the application and re-deploying the data is still available from the persisted source")

		UndeployGuestBook(kubectl)
		DeployGuestBook(kubectl)

		appAddress = kubectl.GetAppAddress(deployment, "svc/frontend")
		Eventually(func() string {
			return GetValueFromGuestBook(appAddress)
		}, "120s", "2s").Should(ContainSubstring(testValue))

	})
})
