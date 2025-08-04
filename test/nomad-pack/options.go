package nomad_pack

// Options for running Nomad Pack commands
type Options struct {
	NomadPackBinary string // Name of the binary that will be used

	PackName     string   // The pack name.
	InstanceName string   // Unique identifier of the deployed instance of the specified pack. If not set, the pack name will be used.
	Namespace    string   // The target namespace for queries and actions bound to a namespace.
	VarFiles     []string // Var file paths to pass to Nomad Pack commands using the --var-file option.
}
