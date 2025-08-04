package test

import (
	"fmt"
	"path/filepath"
	"testing"

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

	nomadPackOptions := &Options{
		PackName:     packDir,
		InstanceName: instanceName,
		VarFiles:     varFiles,
	}

	stage := test_structure.RunTestStage

	defer stage(t, "destroy", func() {
		NomadPackDestroy(t, nomadPackOptions)
	})

	stage(t, "plan", func() {
		NomadPackPlan(t, nomadPackOptions)
	})

	stage(t, "deploy", func() {
		NomadPackRun(t, nomadPackOptions)
	})

	stage(t, "validate", func() {
		NomadPackStatus(t, nomadPackOptions)
	})
}
