package test

import (
	"fmt"
	"path/filepath"
	"testing"

	pack "github.com/flaudisio/nomad-pack-registry/test/nomad-pack"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

func TestWebappComplete(t *testing.T) {
	t.Parallel()

	packDir := "../packs/webapp"
	packName := filepath.Base(packDir)

	exampleDir := "../examples/webapp"
	exampleName := "complete"

	instanceName := fmt.Sprintf("%s-%s", packName, exampleName)
	varFiles := []string{fmt.Sprintf("%s/vars-%s.hcl", exampleDir, exampleName)}
	nomadPackOptions := &pack.Options{
		PackName:     packDir,
		InstanceName: instanceName,
		VarFiles:     varFiles,
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
