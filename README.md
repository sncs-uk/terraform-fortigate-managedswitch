<!-- BEGIN_TF_DOCS -->
# Fortigate Managed Switch configuration module

This terraform module configures managed switches on a FortiGate firewall

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.11.0 |
| <a name="requirement_fortios"></a> [fortios](#requirement\_fortios) | >= 1.22.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_fortios"></a> [fortios](#provider\_fortios) | >= 1.22.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [fortios_json_generic_api.ports](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/json_generic_api) | resource |
| [fortios_switchcontroller_managedswitch.switches](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/switchcontroller_managedswitch) | resource |
| [fortios_switchcontroller_switchgroup.groups](https://registry.terraform.io/providers/fortinetdev/fortios/latest/docs/resources/switchcontroller_switchgroup) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_config_path"></a> [config\_path](#input\_config\_path) | Path to base configuration directory | `string` | n/a | yes |
| <a name="input_force_update"></a> [force\_update](#input\_force\_update) | Whether or not to force update the ports using a timestamp QS | `bool` | `false` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->