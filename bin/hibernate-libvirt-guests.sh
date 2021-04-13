#!/usr/bin/env bash

LIBVIRT_SAVE_PATH=${LIBVIRT_SAVE_PATH:-/var/cache/libvirt/saved}

get_running_vm()
{
     virsh list --name --state-running
}

get_shutoff_vm()
{
    virsh list --name --state-shutoff
}

is_saved_vm()
{
    local vm="$1"
    virsh domstate "$vm" --reason | grep -q "(saved)"
}

save_a_vm()
{
    local vm="$1"
    local save_path="${2:-$LIBVIRT_SAVE_PATH}"
    echo "<INFO> Step: Saving vm $vm to $save_path/$vm.save ..."
    virsh save "$vm" "$save_path/$vm.save" --bypass-cache --running
}

restore_a_vm()
{
    local vm="$1"
    local save_path="${2:-$LIBVIRT_SAVE_PATH}"

    if [ ! -e "$save_path/$vm.save" ]; then
        # save file not exists, ignore it.
        return 0
    fi
    echo "<INFO> Step: Restoring vm $vm from $save_path/$vm.save ..."
    virsh restore "$save_path/$vm.save" --bypass-cache --running
    if [ $? -eq 0 ]; then
        rm -f "$save_path/$vm.save"
    fi
}

save_vms()
{
    if [ ! -e "$LIBVIRT_SAVE_PATH" ]; then
        mkdir -p "$LIBVIRT_SAVE_PATH"
    fi

    local vm
    local IFS=$'\n'
    for vm in $(get_running_vm) ; do
        save_a_vm "$vm"
    done
    echo "<INFO> Step: Save vms done."
}

restore_vms()
{
    local vm
    local IFS=$'\n'
    for vm in $(get_shutoff_vm) ; do
        restore_a_vm "$vm"
    done
    echo "<INFO> Step: Restore vms done."
}

usage()
{
    cat <<-EOF
    Usage:

    * To save all running guests, running:

        ./hibernate-libvirt.sh hibernate
    * To resume all saved guests, running:

        ./hibernate-libvirt.sh resume
EOF
}

action="$1"
case "$action" in
    hibernate)
        save_vms
        ;;
    resume)
        restore_vms
        ;;
    *)
        usage
        ;;
esac
