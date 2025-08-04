package nomad_pack

import (
	"path/filepath"

	"github.com/gruntwork-io/terratest/modules/testing"
	"github.com/stretchr/testify/require"
)

// StatusE will return the status of the selected pack with the provided arguments. This
// will fail the test if there is an error.
func Status(t testing.TestingT, options *Options) string {
	out, err := StatusE(t, options)
	require.NoError(t, err)
	return out
}

// StatusE will return the status of the selected pack with the provided arguments
func StatusE(t testing.TestingT, options *Options) (string, error) {
	// The 'status' command does not support the Pack directory
	packName := filepath.Base(options.PackName)

	args := FormatArgs(options, "status", packName)

	return RunNomadPackCommandE(t, options, args...)
}
