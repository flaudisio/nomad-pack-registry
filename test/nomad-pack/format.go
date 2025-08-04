package nomad_pack

import (
	"fmt"

	"github.com/gruntwork-io/terratest/modules/collections"
)

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
