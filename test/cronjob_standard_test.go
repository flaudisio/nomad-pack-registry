package test

import (
	"fmt"
	"path/filepath"
	"testing"

	pack "github.com/flaudisio/nomad-pack-registry/test/nomad-pack"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

func TestCronjobStandard(t *testing.T) {
	t.Parallel()

	packDir := "../packs/cronjob"
	exampleDir := "../examples/cronjob-standard"

	nomadPackOptions := &pack.Options{
		PackName:     packDir,
		InstanceName: filepath.Base(exampleDir),
		VarFiles:     []string{fmt.Sprintf("%s/variables.hcl", exampleDir)},
	}

	stage := test_structure.RunTestStage

	defer stage(t, "destroy", func() {
		pack.Destroy(t, nomadPackOptions)
	})

	stage(t, "plan", func() {
		pack.Plan(t, nomadPackOptions)
	})

	stage(t, "deploy", func() {
		pack.Run(t, nomadPackOptions)
	})

	stage(t, "validate", func() {
		pack.Status(t, nomadPackOptions)
	})
}
