package generic_test

import (
	"fmt"
	"tests/config"
	. "tests/test_helpers"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/ginkgo/extensions/table"
	. "github.com/onsi/gomega"
	"github.com/onsi/gomega/gbytes"
	"github.com/onsi/gomega/gexec"
)

var _ = Describe("check apply-specs errand has run correctly", func() {
	var (
		kubectl    *KubectlRunner
		testconfig *config.Config
		err        error
	)

	BeforeSuite(func() {
		testconfig, err = config.InitConfig()
		Expect(err).NotTo(HaveOccurred())
	})

	BeforeEach(func() {
		kubectl = NewKubectlRunner(testconfig.Kubernetes.PathToKubeConfig)
	})

	DescribeTable("all deployments have rolled out", func(deploymentName string) {
		session := kubectl.RunKubectlCommandInNamespace("default", "rollout", "status", fmt.Sprintf("deployment/%s", deploymentName), "-w")
		Eventually(session, "120s").Should(gexec.Exit(0))
		Eventually(session, "120s").Should(gbytes.Say(fmt.Sprintf("deployment \"%s\" successfully rolled out", deploymentName)))
	},
		Entry("frontend", "frontend"),
		Entry("redis-slave", "redis-slave"),
		Entry("redis-master", "redis-master"),
	)
})
