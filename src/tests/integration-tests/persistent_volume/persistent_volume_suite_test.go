package persistent_volume_test

import (
	"tests/config"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"

	"fmt"
	"testing"
)

var iaas string
var deploymentName string

func TestPersistentVolume(t *testing.T) {
	RegisterFailHandler(Fail)
	RunSpecs(t, "PersistentVolume Suite")
}

var _ = BeforeSuite(func() {
	testconfig, err := config.InitConfig()
	Expect(err).NotTo(HaveOccurred())

	platforms := []string{"aws", "gcp", "vsphere"}
	message := fmt.Sprintf("Expected IAAS to be one of the following values: %#v", platforms)
	Expect(platforms).To(ContainElement(testconfig.Bosh.Iaas), message)
})
