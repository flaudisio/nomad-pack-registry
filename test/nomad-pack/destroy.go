package nomad_pack

import (
	"github.com/gruntwork-io/terratest/modules/testing"
	"github.com/stretchr/testify/require"
)

// Destroy will destroy the selected pack with the provided arguments. This will fail
// the test if there is an error.
func Destroy(t testing.TestingT, options *Options) string {
	out, err := DestroyE(t, options)
	require.NoError(t, err)
	return out
}

// DestroyE will destroy the selected pack with the provided arguments
func DestroyE(t testing.TestingT, options *Options) (string, error) {
	args := FormatArgs(options, "destroy", options.PackName)

	return RunNomadPackCommandE(t, options, args...)
}
