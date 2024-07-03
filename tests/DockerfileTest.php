<?php

use PHPUnit\Framework\TestCase;

class DockerfileTest extends TestCase
{
    /**
     * Test Dockerfile build and run.
     */
    public function testDockerfileBuild()
    {
        // Path to your Dockerfile
        $dockerfilePath = __DIR__ . '/../src/Dockerfile';

        // Check if Dockerfile exists
        $this->assertFileExists($dockerfilePath, 'Dockerfile not found.');

        // Build Docker image
        $output = shell_exec("docker build -t humhub-docker -f $dockerfilePath . 2>&1");

        // Check if image build was successful
        $this->assertStringContainsString('Successfully built', $output, 'Docker build failed: ' . $output);

        // Clean up: remove test image
        $cleanupOutput = shell_exec("docker rmi humhub-docker 2>&1");
        if ($cleanupOutput !== null) {
            echo "Cleanup output: " . $cleanupOutput . "\n";
        }
    }
}
