/**
 * # Fortigate Managed Switch configuration module
 *
 * This terraform module configures managed switches on a FortiGate firewall
 */
terraform {
  required_version = ">= 1.32.0"
  required_providers {
    fortios = {
      source  = "fortinetdev/fortios"
      version = ">= 1.22.0"
    }
  }
}
locals {
  switches_yaml  = fileexists("${var.config_path}/managed-switches.yaml") ? yamldecode(file("${var.config_path}/managed-switches.yaml")) : object({})


  ports = flatten([
    for switchname, switch in try(local.switches_yaml.switches, []) : [
      for port_name, port in try(switch.ports, []) : {
        switch              = switchname
        port_name           = port_name
        port                = port
      }
    ]
  ])

  suffix = var.force_update ? "?timestamp=${timestamp()}" : ""
}


resource fortios_switchcontroller_managedswitch switches {
  for_each                      = { for name, switch in try(local.switches_yaml.switches, []) : name => switch }

  switch_id                     = each.key
  sn                            = each.value.sn
  # name                          = each.key
  fsw_wan1_peer                 = each.value.fsw_wan1_peer
  fsw_wan1_admin                = each.value.fsw_wan1_admin

  description                   = try(each.value.description, null)
  switch_profile                = try(each.value.switch_profile, null)
  access_profile                = try(each.value.access_profile, null)
  purdue_level                  = try(each.value.purdue_level, null)
  fsw_wan2_peer                 = try(each.value.fsw_wan2_peer, null)
  fsw_wan2_admin                = try(each.value.fsw_wan2_admin, null)
  poe_pre_standard_detection    = try(each.value.poe_pre_standard_detection, null)
  dhcp_server_access_list       = try(each.value.dhcp_server_access_list, null)
  poe_detection_type            = try(each.value.poe_detection_type, null)
  poe_lldp_detection            = try(each.value.poe_lldp_detection, null)
  directly_connected            = try(each.value.directly_connected, null)
  version                       = try(each.value.version, null)
  max_allowed_trunk_members     = try(each.value.max_allowed_trunk_members, null)
  pre_provisioned               = try(each.value.pre_provisioned, null)
  l3_discovered                 = try(each.value.l3_discovered, null)
  mgmt_mode                     = try(each.value.mgmt_mode, null)
  tunnel_discovered             = try(each.value.tunnel_discovered, null)
  tdr_supported                 = try(each.value.tdr_supported, null)
  dynamic_capability            = try(each.value.dynamic_capability, null)
  switch_device_tag             = try(each.value.switch_device_tag, null)
  switch_dhcp_opt43_key         = try(each.value.switch_dhcp_opt43_key, null)
  mclag_igmp_snooping_aware     = try(each.value.mclag_igmp_snooping_aware, null)
  dynamically_discovered        = try(each.value.dynamically_discovered, null)
  ptp_status                    = try(each.value.ptp_status, null)
  ptp_profile                   = try(each.value.ptp_profile, null)
  radius_nas_ip_override        = try(each.value.radius_nas_ip_override, null)
  radius_nas_ip                 = try(each.value.radius_nas_ip, null)
  route_offload                 = try(each.value.route_offload, null)
  route_offload_mclag           = try(each.value.route_offload_mclag, null)
  # vlan                          = try(each.value.vlan, null)
  type                          = try(each.value.type, null)
  owner_vdom                    = try(each.value.owner_vdom, null)
  flow_identity                 = try(each.value.flow_identity, null)
  staged_image_version          = try(each.value.staged_image_version, null)
  delayed_restart_trigger       = try(each.value.delayed_restart_trigger, null)
  firmware_provision            = try(each.value.firmware_provision, null)
  firmware_provision_version    = try(each.value.firmware_provision_version, null)
  firmware_provision_latest     = try(each.value.firmware_provision_latest, null)
  # ip_source_guard               = try(each.value.ip_source_guard, null)
  # stp_settings                  = try(each.value.stp_settings, null)
  # stp_instance                  = try(each.value.stp_instance, null)
  override_snmp_trap_threshold  = try(each.value.override_snmp_trap_threshold, null)
  # snmp_trap_threshold           = try(each.value.snmp_trap_threshold, null)
  qos_drop_policy               = try(each.value.qos_drop_policy, null)
  qos_red_probability           = try(each.value.qos_red_probability, null)
  # switch_stp_settings           = try(each.value.switch_stp_settings, null)
  # switch_log                    = try(each.value.switch_log, null)
  # remote_log                    = try(each.value.remote_log, null)
  # storm_control                 = try(each.value.storm_control, null)
  # mirror                        = try(each.value.mirror, null)
  # static_mac                    = try(each.value.static_mac, null)
  # custom_command                = try(each.value.custom_command, null)
  # dhcp_snooping_static_client   = try(each.value.dhcp_snooping_static_client, null)
  # igmp_snooping                 = try(each.value.igmp_snooping, null)
  # n802_1x_settings              = try(each.value.n802_1x_settings, null)
  dynamic_sort_subtable         = "natural"
  get_all_tables                = try(each.value.get_all_tables, null)
  vdomparam                     = try(each.value.vdomparam , null)

  override_snmp_sysinfo         = try(each.value.snmp, null) == null ? "disable" : "enable"
  snmp_sysinfo {
    status          = try(each.value.snmp.status, "disable")
    engine_id       = try(each.value.snmp.engine_id, null)
    description     = try(each.value.snmp.description, null)
    contact_info    = try(each.value.snmp.contact_info, null)
    location        = try(each.value.snmp.location, null)
  }

  override_snmp_community       = try(each.value.snmp.communities, null) == null ? "disable" : "enable"
  dynamic snmp_community {
    for_each        = try(each.value.snmp.communities, {})
    content {
      id                = index(each.value.snmp.communities, snmp_community.value) + 1
      name              = try(snmp_community.value.name, null)
      status            = try(snmp_community.value.status, "enable")
      query_v1_status   = (try(snmp_community.value.version, "v2c") == "v1") ? "enable" : "disable"
      query_v1_port     = (try(snmp_community.value.version, "v2c") == "v1") ? try(snmp_community.value.port, null) : null
      query_v2c_status  = (try(snmp_community.value.version, "v2c") == "v2c") ? "enable" : "disable"
      query_v2c_port    = (try(snmp_community.value.version, "v2c") == "v2c") ? try(snmp_community.value.port, null) : null
      dynamic hosts {
        for_each       = try(snmp_community.value.hosts, {})
        content {
          id        = index(snmp_community.value.hosts, hosts.value) + 1
          ip        = hosts.value
        }
      }
    }
  }

  override_snmp_user            = try(each.value.snmp.users, null) == null ? "disable" : "enable"
  dynamic snmp_user {
    for_each        = try(each.value.snmp.users, {})
    content {
      name              = try(snmp_user.value.name, null)
      queries           = try(snmp_user.value.queries, "enable")
      query_port        = try(snmp_user.value.query_port, null)
      security_level    = try(snmp_user.value.security_level, null)
      auth_proto        = try(snmp_user.value.auth_proto, null)
      auth_pwd          = try(snmp_user.value.auth_pwd, null)
      priv_proto        = try(snmp_user.value.priv_proto, null)
      priv_pwd          = try(snmp_user.value.priv_pwd, null)
    }
  }

  lifecycle {
    ignore_changes = [
      tdr_supported,
      directly_connected,
      dynamically_discovered
    ]
  }

}


resource fortios_json_generic_api ports {
  for_each = { for port in local.ports : "${port.switch}_${port.port_name}" => port }
  path     = "/api/v2/cmdb/switch-controller/managed-switch/${each.value.switch}/ports/${each.value.port_name}${local.suffix}"
  method   = "PUT"
  json     = jsonencode(each.value.port)
}

resource fortios_switchcontroller_switchgroup groups {
  for_each              = { for group in try(local.switches_yaml.groups, []) : group.name => group }

  name                  = each.key
  description           = try(each.value.description, null)
  fortilink             = try(each.value.fortilink, null)
  vdomparam             = try(each.value.vdomparam, null)

  dynamic members {
    for_each          = { for switch in each.value.members : switch => switch }
    content {
      switch_id       = members.value
    }
  }
}
