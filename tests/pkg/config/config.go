package config

import (
	"errors"
	"io/ioutil"
	"os"

	"gopkg.in/yaml.v2"
)

// Config holds the basic structure of test's YAML file
type Config struct {
	ClusterName string                `yaml:"clusterName"`
	Namespaces  map[string]K8SObjects `yaml:"namespaces"`
}

// K8SObjects are kubernetes objects nested from namespaces, we need to check
// these resources are checked for its existence
type K8SObjects struct {
	Daemonsets []string `yaml:"daemonset"`
	Services   []string `yaml:"services"`
	Secrets    []string `yaml:"secrets"`
}

// ParseConfigFile loads the test file supplied
func ParseConfigFile(f string) (*Config, error) {
	testsFilePath, err := ioutil.ReadFile(f)
	if err != nil {
		return nil, err
	}

	t := Config{}

	err = yaml.Unmarshal(testsFilePath, &t)
	if err != nil {
		return nil, err
	}

	err = t.defaultsFromEnvs()
	if err != nil {
		return nil, err
	}

	return &t, nil
}

// defaultsFromEnvs process the mandatory fields in the config. If they are not set,
// it tries to load them from environment variables
func (c Config) defaultsFromEnvs() error {
	if c.ClusterName == "" {
		c.ClusterName = os.Getenv("CP_CLUSTER_NAME")
		if c.ClusterName == "" {
			return errors.New("Cluster Name is mandatory - not found it neither in config file nor environment variable")
		}
	}

	return nil
}

// defaultsFromEnvs process the mandatory fields in the config. If they are not set,
// it tries to load them from environment variables
func (c *Config) GetDaemonSets() error {

	return nil
}
