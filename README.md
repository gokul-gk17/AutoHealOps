# AutoHealOps
## Automated Deployment, Monitoring and Self-Healing of a MongoDB-Based Application

AutoHealOps is an infrastructure automation project that combines Ansible,
Nagios Core and Puppet to deploy, monitor and recover a Node.js application.

## 1. Project Objectives

- Monitor application availability and infrastructure services.
- Detect application failures using Nagios Core.
- Trigger automated application recovery using an Ansible event handler.
- Verify application health after recovery.
- Enforce service availability using Puppet.
- Detect and correct configuration drift using Puppet.
- Monitor MongoDB TCP connectivity.

## 2. Technology Stack

- Node.js and Express
- MongoDB
- Ubuntu Linux
- Nginx
- Ansible
- Nagios Core 4
- Puppet Server and Puppet Agent
- SSH
- systemd

## 3. Architecture

### Application VM
Runs the Dev Wrapped application, Node.js service and Nginx reverse proxy.
It also runs the Puppet Agent.

### Monitoring and Automation Machine
Runs Nagios Core and Ansible. Nagios monitors the application and invokes
the Ansible recovery playbook when the API reaches a HARD CRITICAL state.

### Puppet Server
Compiles and provides configuration catalogs to the Puppet Agent.

### MongoDB Host
Runs MongoDB and provides database connectivity to the application.
Nagios monitors TCP connectivity to MongoDB port 27017.

## 4. Self-Healing Workflow

1. Nagios periodically checks the Dev Wrapped API.
2. The API becomes unavailable.
3. Nagios detects the failure and reaches HARD CRITICAL state.
4. The Nagios event handler invokes the Ansible playbook.
5. Ansible restarts the devwrapped systemd service.
6. Ansible waits for port 3000 to become available.
7. Ansible verifies the API health endpoint.
8. Nagios detects the restored HTTP 200 response.

## 5. Puppet Configuration Management

The Puppet manifest enforces:

- devwrapped service: running and enabled.
- nginx service: running and enabled.
- /etc/autohealops-managed.conf: expected content, ownership and permissions.

The Puppet Agent runs periodically and can also be triggered manually.

## 6. MongoDB Monitoring

Nagios uses the check_tcp plugin to monitor TCP connectivity to MongoDB
on port 27017.

This verifies network and port availability. It does not verify MongoDB
authentication, database queries or application-level database health.

MongoDB failure detection and recovery to the Nagios OK state were tested.
Automated MongoDB restart is not part of the current implementation.

## 7. Repository Structure

```text
autohealops/
├── inventory/
│   └── hosts.ini.example
├── playbooks/
│   └── restart_devwrapped.yml
├── nagios/
│   ├── autohealops.cfg
│   └── scripts/
│       └── autohealops-event-handler
├── puppet/
│   └── manifests/
│       └── site.pp
├── docs/
├── screenshots/
├── logs/
├── .gitignore
└── README.md
```
