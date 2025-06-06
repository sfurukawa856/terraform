package test

import (
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestAPIGatewayReturns200(t *testing.T) {
	t.Parallel()

	opts := &terraform.Options{
		TerraformDir: "../example",
	}

	// テストの最後にすべてを後片付け
	defer terraform.Destroy(t, opts)

	// サンプルをデプロイ
	terraform.InitAndApply(t, opts)

	// Terraform の output から API Gateway の URL を取得
	base_url := terraform.OutputRequired(t, opts, "base_url")

	// 最大で10回リトライ（デプロイ直後の反映待ち対策）
	expectedStatus := 200
	expectedBody := `{"message":"Hello, World!"}`
	maxRetries := 10
	timeBetweenRetries := 5 * time.Second

	http_helper.HttpGetWithRetry(
		t,
		base_url,
		nil,
		expectedStatus,
		expectedBody,
		maxRetries,
		timeBetweenRetries,
	)
}
