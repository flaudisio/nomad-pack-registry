package test

import (
	"strings"

	"github.com/gruntwork-io/terratest/modules/shell"
	"github.com/gruntwork-io/terratest/modules/testing"
	"github.com/stretchr/testify/require"
)

// NomadPackPlan will plan the selected pack with the provided arguments. This will fail
// the test if there is an error.
func NomadPackPlan(t testing.TestingT, packName string, name string, varFile string) {
	require.NoError(t, NomadPackPlanE(t, packName, name, varFile))
}

// NomadPackPlanE will plan the selected pack with the provided arguments
func NomadPackPlanE(t testing.TestingT, packName string, name string, varFile string) error {
	cmd := shell.Command{
		Command: "nomad-pack",
		Args:    []string{"plan", packName, "--name", name, "--var-file", varFile},
	}

	output, err := shell.RunCommandAndGetOutputE(t, cmd)

	// `nomad-pack plan` exits with code 1 even when succeeded, so we must check its output
	if !strings.Contains(output, "Plan succeeded") {
		return err
	}

	return nil
}

// NomadPackRun will run the selected pack with the provided arguments. This will fail
// the test if there is an error.
func NomadPackRun(t testing.TestingT, packName string, name string, varFile string) {
	require.NoError(t, NomadPackRunE(t, packName, name, varFile))
}

// NomadPackRunE will run the selected pack with the provided arguments
func NomadPackRunE(t testing.TestingT, packName string, name string, varFile string) error {
	cmd := shell.Command{
		Command: "nomad-pack",
		Args:    []string{"run", packName, "--name", name, "--var-file", varFile},
	}

	return shell.RunCommandE(t, cmd)
}

// NomadPackStatusE will return the status of the selected pack with the provided arguments. This
// will fail the test if there is an error.
func NomadPackStatus(t testing.TestingT, packName string, name string, namespace string) {
	require.NoError(t, NomadPackStatusE(t, packName, name, namespace))
}

// NomadPackStatusE will return the status of the selected pack with the provided arguments
func NomadPackStatusE(t testing.TestingT, packName string, name string, namespace string) error {
	if namespace == "" {
		namespace = "default"
	}

	cmd := shell.Command{
		Command: "nomad-pack",
		Args:    []string{"status", packName, "--name", name, "--namespace", namespace},
	}

	return shell.RunCommandE(t, cmd)
}

// NomadPackDestroy will destroy the selected pack with the provided arguments. This will fail
// the test if there is an error.
func NomadPackDestroy(t testing.TestingT, packName string, name string, namespace string) {
	require.NoError(t, NomadPackDestroyE(t, packName, name, namespace))
}

// NomadPackDestroyE will destroy the selected pack with the provided arguments
func NomadPackDestroyE(t testing.TestingT, packName string, name string, namespace string) error {
	if namespace == "" {
		namespace = "default"
	}

	cmd := shell.Command{
		Command: "nomad-pack",
		Args:    []string{"destroy", packName, "--name", name, "--namespace", namespace},
	}

	return shell.RunCommandE(t, cmd)
}
