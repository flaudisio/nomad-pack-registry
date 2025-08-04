package nomad_pack

import (
	"github.com/gruntwork-io/terratest/modules/shell"
	"github.com/gruntwork-io/terratest/modules/testing"
	"github.com/stretchr/testify/require"
)

// Plan will plan the selected pack with the provided arguments. This will fail
// the test if there is an error.
func Plan(t testing.TestingT, options *Options) string {
	out, err := PlanE(t, options)
	require.NoError(t, err)
	return out
}

// PlanE will plan the selected pack with the provided arguments
func PlanE(t testing.TestingT, options *Options) (string, error) {
	args := FormatArgs(options, "plan", options.PackName, "--verbose")

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
