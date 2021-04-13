
** DO NOT USE **

The script is not work as expected. I assume it should save on hibernate and restore on resume.
But from the log, it seems the save step do not finish on hibernate, but on resume.

```
Apr 13 13:05:50 stable systemd[1]: Starting Save all running libvirt guests on hibernate...
Apr 13 13:05:50 stable hibernate-libvirt-guests.sh[72789]: <INFO> Step: Saving vm centos7.0 to /var/cache/libvirt/saved/centos7.0.save ...
Apr 13 13:05:51 stable systemd-sleep[72808]: Suspending system...
Apr 13 13:07:41 stable kernel: ACPI: Preparing to enter system sleep state S4
Apr 13 13:07:41 stable kernel: ACPI: Waking up from system sleep state S4
Apr 13 13:07:41 stable kernel: amdgpu 0000:05:00.0: amdgpu: SMU is resumed successfully!

Apr 13 13:07:41 stable systemd-sleep[72808]: System resumed.
Apr 13 13:08:27 stable hibernate-libvirt-guests.sh[72796]: Domain 'centos7.0' saved to /var/cache/libvirt/saved/centos7.0.save
Apr 13 13:08:27 stable hibernate-libvirt-guests.sh[72789]: <INFO> Step: Save vms done.
Apr 13 13:08:28 stable systemd[1]: Finished Save all running libvirt guests on hibernate.
```

I do not have time to debug into it.
