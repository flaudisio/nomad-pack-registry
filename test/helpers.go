package test

import (
	"fmt"

	"github.com/gruntwork-io/terratest/modules/collections"
	"github.com/gruntwork-io/terratest/modules/shell"
	"github.com/gruntwork-io/terratest/modules/testing"
	"github.com/stretchr/testify/require"
)

const (
	// NomadPackDefaultPath to run nomad-pack
	NomadPackDefaultPath = "nomad-pack"
)

// Options for running Nomad Pack commands
type Options struct {
	NomadPackBinary string // Name of the binary that will be used

	PackName     string   // The pack name.
	InstanceName string   // Unique identifier of the deployed instance of the specified pack. If not set, the pack name will be used.
	Namespace    string   // The target namespace for queries and actions bound to a namespace.
	VarFiles     []string // Var file paths to pass to Nomad Pack commands using the --var-file option.
}

// NomadPackCommandsWithNamespaceSupport is a list of all Nomad Pack commands that support using
// Nomad namespaces.
var NomadPackCommandsWithNamespaceSupport = []string{
	"destroy",
	"list",
	"plan",
	"run",
	"status",
	"stop",
}

// NomadPackCommandsWithVarFileSupport is a list of all Nomad Pack commands that support interacting
// with var files.
var NomadPackCommandsWithVarFileSupport = []string{
	"info",
	"list",
	"plan",
	"render",
	"run",
	"status",
	"stop",
}

// FormatArgs converts the inputs to a format palatable to Nomad Pack. This includes converting the given vars to the
// format the Nomad Pack CLI expects.
func FormatArgs(options *Options, args ...string) []string {
	nomadPackArgs := args
	commandType := args[0]

	if options.InstanceName != "" {
		nomadPackArgs = append(nomadPackArgs, fmt.Sprintf("--name=%s", options.InstanceName))
	}

	namespaceSupported := collections.ListContains(NomadPackCommandsWithNamespaceSupport, commandType)

	if namespaceSupported && options.Namespace != "" {
		nomadPackArgs = append(nomadPackArgs, fmt.Sprintf("--namespace=%s", options.Namespace))
	}

	varFileSupported := collections.ListContains(NomadPackCommandsWithVarFileSupport, commandType)

	if varFileSupported && options.VarFiles != nil {
		for _, file := range options.VarFiles {
			nomadPackArgs = append(nomadPackArgs, fmt.Sprintf("--var-file=%s", file))
		}
	}

	return nomadPackArgs
}

// GetCommonOptions extracts commons Nomad Pack options
func GetCommonOptions(options *Options) *Options {
	if options.NomadPackBinary == "" {
		options.NomadPackBinary = NomadPackDefaultPath
	}

	return options
}

// RunNomadPackCommandE runs nomad-pack with the given arguments and options and return stdout/stderr
func RunNomadPackCommandE(t testing.TestingT, additionalOptions *Options, args ...string) (string, error) {
	options := GetCommonOptions(additionalOptions)

	cmd := shell.Command{
		Command: options.NomadPackBinary,
		Args:    args,
	}

	return shell.RunCommandAndGetOutputE(t, cmd)
}

// NomadPackPlan will plan the selected pack with the provided arguments. This will fail
// the test if there is an error.
func NomadPackPlan(t testing.TestingT, options *Options) string {
	out, err := NomadPackPlanE(t, options)
	require.NoError(t, err)

	return out
}

// NomadPackPlanE will plan the selected pack with the provided arguments
func NomadPackPlanE(t testing.TestingT, options *Options) (string, error) {
	args := FormatArgs(options, "plan", options.PackName)
	out, err := RunNomadPackCommandE(t, options, args...)

	// Plan will return one of the following exit codes:
	// 	* code 0:   No objects will be created or destroyed.
	// 	* code 1:   Objects will be created or destroyed.
	// 	* code 255: An error occurred determining the plan.
	exitCode, _ := shell.GetExitCodeForRunCommandError(err)
	if exitCode == 0 || exitCode == 1 {
		err = nil
	}

	return out, err
}

// NomadPackRun will run the selected pack with the provided arguments. This will fail
// the test if there is an error.
func NomadPackRun(t testing.TestingT, options *Options) string {
	out, err := NomadPackRunE(t, options)
	require.NoError(t, err)

	return out
}

// NomadPackRunE will run the selected pack with the provided arguments
func NomadPackRunE(t testing.TestingT, options *Options) (string, error) {
	args := FormatArgs(options, "run", options.PackName)

	return RunNomadPackCommandE(t, options, args...)
}

// NomadPackDestroy will destroy the selected pack with the provided arguments. This will fail
// the test if there is an error.
func NomadPackDestroy(t testing.TestingT, options *Options) string {
	out, err := NomadPackDestroyE(t, options)
	require.NoError(t, err)

	return out
}

// NomadPackDestroyE will destroy the selected pack with the provided arguments
func NomadPackDestroyE(t testing.TestingT, options *Options) (string, error) {
	args := FormatArgs(options, "destroy", options.PackName)

	return RunNomadPackCommandE(t, options, args...)
}

// NomadPackStatusE will return the status of the selected pack with the provided arguments. This
// will fail the test if there is an error.
func NomadPackStatus(t testing.TestingT, options *Options) string {
	out, err := NomadPackStatusE(t, options)
	require.NoError(t, err)

	return out
}

// NomadPackStatusE will return the status of the selected pack with the provided arguments
func NomadPackStatusE(t testing.TestingT, options *Options) (string, error) {
	args := FormatArgs(options, "status", options.PackName)

	return RunNomadPackCommandE(t, options, args...)
}
