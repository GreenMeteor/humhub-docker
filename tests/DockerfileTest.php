<?php

use PHPUnit\Framework\TestCase;

class DockerfileTest extends TestCase
{
    private $dockerImageName = 'humhub-docker';

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
        $output = shell_exec("docker build -t {$this->dockerImageName} -f $dockerfilePath . 2>&1");

        // Check if image build was successful
        $this->assertStringContainsString('Successfully built', $output, 'Docker build failed: ' . $output);

        // Optionally, you can run a container from the built image to ensure it works
        $containerId = trim(shell_exec("docker run -d {$this->dockerImageName}"));
        $this->assertNotEmpty($containerId, 'Failed to run Docker container.');

        // Verify the container is running
        $containerStatus = trim(shell_exec("docker ps -f id=$containerId --format '{{.Status}}'"));
        $this->assertStringContainsString('Up', $containerStatus, 'Docker container is not running.');

        // Stop and remove the container
        shell_exec("docker stop $containerId");
        shell_exec("docker rm $containerId");

        // Clean up: remove test image
        $cleanupOutput = shell_exec("docker rmi {$this->dockerImageName} 2>&1");
        if ($cleanupOutput !== null) {
            echo "Cleanup output: " . $cleanupOutput . "\n";
        }
    }
}
