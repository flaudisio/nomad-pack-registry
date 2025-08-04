package nomad_pack

import (
	"github.com/gruntwork-io/terratest/modules/testing"
	"github.com/stretchr/testify/require"
)

// Run will run the selected pack with the provided arguments. This will fail
// the test if there is an error.
func Run(t testing.TestingT, options *Options) string {
	out, err := RunE(t, options)
	require.NoError(t, err)
	return out
}

// RunE will run the selected pack with the provided arguments
func RunE(t testing.TestingT, options *Options) (string, error) {
	args := FormatArgs(options, "run", options.PackName)

	return RunNomadPackCommandE(t, options, args...)
}
