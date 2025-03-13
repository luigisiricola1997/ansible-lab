# Ansible Docker Test

This project sets up a Docker environment to test Ansible playbooks.

## Prerequisites

- Docker
- Docker Compose

## Setup

1. Clone the repository:
    ```sh
    git clone <repository-url>
    cd ansible-docker-test
    ```

2. Start the Docker containers:
    ```sh
    docker-compose up -d
    ```

3. Run the Ansible playbook:
    ```sh
    docker exec -ti ansible_host ansible-playbook -i /root/hosts /root/test.yml
    ```

## Project Structure

- `docker-compose.yml`: Docker Compose configuration file.
- `hosts`: Ansible inventory file.
- `LICENSE`: License file.
- `README.md`: This file.
- `test.yml`: Ansible playbook.
- `.vscode/settings.json`: VSCode settings for Ansible.
- `roles/test/tasks/main.yml`: Ansible role tasks.

## License

This project is licensed under the GNU General Public License v3.0. See the [LICENSE](LICENSE) file for details.
