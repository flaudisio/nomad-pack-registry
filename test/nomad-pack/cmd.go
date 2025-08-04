package nomad_pack

import (
	"github.com/gruntwork-io/terratest/modules/shell"
	"github.com/gruntwork-io/terratest/modules/testing"
)

const (
	// Default path of the nomad-pack binary
	NomadPackDefaultPath = "nomad-pack"
)

// RunNomadPackCommandE runs nomad-pack with the given arguments and options and return stdout/stderr
func RunNomadPackCommandE(t testing.TestingT, options *Options, args ...string) (string, error) {
	cmdPath := NomadPackDefaultPath

	if options.NomadPackBinary != "" {
		cmdPath = options.NomadPackBinary
	}

	cmd := shell.Command{
		Command: cmdPath,
		Args:    args,
	}

	return shell.RunCommandAndGetOutputE(t, cmd)
}
