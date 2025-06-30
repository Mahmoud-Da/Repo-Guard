# RepoGuard 🛡️

RepoGuard is an automated utility that ensures the `main` and `master` branches of all your personal repositories are protected. It uses a shell script powered by the GitHub CLI, containerized with Docker, and automated with GitHub Actions. It can also be run easily on your local machine.

## Features

- **Automated**: Runs every hour via GitHub Actions.
- **Local Execution**: Can be run locally using a `.env` file for configuration.
- **Comprehensive**: Scans up to 1000 of your personal repositories.
- **Containerized**: Uses a minimal Docker container for a consistent execution environment in CI/CD.
- **Secure**: Applies a standard set of branch protection rules.

---

## How to Run (Two Ways)

### Option 1: Automated with GitHub Actions (Recommended)

Follow these steps to set up the hourly automated job.

1.  Go to your GitHub **Settings**.
2.  Navigate **Developer settings** > **Personal access tokens** > **Tokens (classic)**.
    - Generate a new classic token with the full `repo` scope.
3.  - Click **Generate new token**.
4.  Fill out the token details:
    - **Token name**: Give it a clear name, like `RepoGuard Branch Protection`.
    - **Expiration**: Set a reasonable expiration, like `90 days`.
    - **Repository access**: Select **All repositories**. The script needs to be able to scan all of your repos.
5.  Under **Permissions**, click on **Repository permissions**.
6.  Grant the following **three** specific permissions:

| Permission         | Access Level   | Why it's needed                                                                     |
| :----------------- | :------------- | :---------------------------------------------------------------------------------- |
| **Administration** | `Read & write` | **Required.** This allows the script to apply/update branch protection rules.       |
| **Contents**       | `Read-only`    | **Required.** This allows the script to check if `main` or `master` branches exist. |
| **Metadata**       | `Read-only`    | **Required.** This allows the `gh repo list` command to discover your repositories. |

7.  Leave all other permissions set to `No access`.
8.  Click **Generate token**.
9.  **Important**: Copy the token immediately. You will not be able to see it again.

The GitHub Action will now run every hour. You can also trigger it manually from the "Actions" tab.

### Option 2: Running Locally on Your Machine

This is useful for testing or for a one-time run.

1.  **Install GitHub CLI**: Follow the official instructions to [install `gh`](https://cli.github.com/).

2.  **Clone the Repository**:

    ```bash
    git clone https://github.com/your-username/RepoGuard.git
    cd RepoGuard
    ```

3.  **Create your `.env` file**:

    - Copy the example file:
      ```bash
      cp .env.example .env
      ```
    - Open the new `.env` file and replace the placeholder with your **Personal Access Token (PAT)**.

4.  **Make the script executable**:

    ```bash
    chmod +x protect-branches.sh
    ```

5.  **Run the script**:
    ```bash
    ./protect-branches.sh
    ```
