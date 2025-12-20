<p align="center">
 <a href="https://talos.dev">
  <img src="./docs/images/logo.png" width=150 alt="OpenTofu logo" />
 </a>
</p>

<h1 align="center">
  OpenTofu (Terraform) Module Library
</h1>

<p align="center">
  A collection of modules for OpenTofu (Terraform).
</p>

<p align="center">
  <a href="https://code.visualstudio.com/"><img src="https://img.shields.io/badge/VSCode-0078D4?style=for-the-badge&logo=visual%20studio%20code&logo=visual-studio-code&logoColor=white" alt="VSCode" /></a>
  <a href="https://opentofu.org"><img src="https://img.shields.io/badge/opentofu-FCC624?style=for-the-badge&logo=opentofu&logoColor=black" alt="OpenTofu" /></a>
  <a href="https://www.hashicorp.com/en/products/terraform"><img src="https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white" alt="Terraform" /></a>
  <a href="#"><img src="https://img.shields.io/badge/Linux-a80030?style=for-the-badge&logo=linux&logoColor=white" alt="Linux" /></a>
  <a href="#"><img src="https://img.shields.io/badge/mac%20os-000000?style=for-the-badge&logo=apple&logoColor=white" alt="MacOS" /></a>
  <br />
  <a href="#"><img src="https://img.shields.io/badge/stability-alpha-red?style=for-the-badge" alt="alpha Stability" /></a>
  <a href="https://en.wikipedia.org/wiki/MIT_License" target="_blank"><img src="https://img.shields.io/badge/license-MIT-blue?style=for-the-badge" alt="MIT License" /></a>
  <a href="#"><img src="https://img.shields.io/badge/support-community-darkgreen?style=for-the-badge" alt="Community Supported" /></a>
  <a href="#"><img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/innotegrity/tf-talos?style=for-the-badge&color=purple&logo=github&logoColor=white" alt="GitHub Stars" /></a>
</p>
<br />

<!-- omit in toc -->
## Table of Contents

- [✅ Requirements](#-requirements)
- [📦 Available Modules](#-available-modules)
- [📃 License](#-license)
- [❓ Questions, Issues and Feature Requests](#-questions-issues-and-feature-requests)

## ✅ Requirements

The modules in this repository require the following software:

- OpenTofu 1.11 or later OR Terraform 1.14 or later
- MacOS 26 or later OR most Linux variants

This repository is configured for Visual Studio Code with the following extensions installed:

- [OpenTofu (official)](https://marketplace.visualstudio.com/items?itemName=OpenTofu.vscode-opentofu)
- [HashiCorp Terraform](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform)
- [markdownlint](https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint)

## 📦 Available Modules

The following modules are available within this repository:

- [Proxmox CSI Module](./proxmox-csi/README.md): Module for installing the Proxmox CSI driver inside of a Kubernetes cluster
- [Proxmox CSI User Module](./proxmox-csi-user/README.md): Module for creating the necessary Proxmox user, role and token for use with the Proxmox CSI driver
- [Talos Cluster Module](./talos-vm/README.md): Module for creating a Talos cluster from a set of VMs
- [Talos ISO Image Module](./talos-image/README.md): Module for downloading a factory-generated Talos ISO image
- [Talos VM Module](./talos-vm/README.md): Module for creating a Talos Linux virtual machine

## 📃 License

This software is distributed under the MIT License.

## ❓ Questions, Issues and Feature Requests

If you have questions about this project, find a bug or wish to submit a feature request, please [submit an issue](https://github.com/innotegrity/tf-modules/issues).
