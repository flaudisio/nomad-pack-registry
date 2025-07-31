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

	deployName := fmt.Sprintf("%s-%s", packName, exampleName)
	varFile := fmt.Sprintf("%s/vars-%s.hcl", exampleDir, exampleName)

	stage := test_structure.RunTestStage

	defer stage(t, "cleanup", func() {
		NomadPackDestroy(t, packName, deployName, "")
	})

	stage(t, "deploy", func() {
		NomadPackPlan(t, packDir, deployName, varFile)
		NomadPackRun(t, packDir, deployName, varFile)
	})

	stage(t, "validate", func() {
		NomadPackStatus(t, packName, deployName, "")
	})
}
