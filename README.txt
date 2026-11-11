OPEN-SOURCE BUG RESEARCH — STUDY FIRST, PATCH LATER
20 independent folders; 6,804 question-bank blocks are not 6,804 verified bugs.
Each bug folder has START_HERE.txt, UPSTREAM.txt and REPRODUCE_LATER.txt.
Entry: customer action -> first source path -> required state -> broken dependency -> proof condition.
No patch has been applied. No reported defect has been reproduced locally in this work.
SQLite smoke test on sandbox SQLite 3.46.1: 600 committed rows, 600 PASSIVE checkpoint calls, integrity_check=ok; WAL-reset corruption NOT reproduced.
Do not invent developer motives or describe an upstream issue as a verified fix.
Cloud Hypervisor #6439 reports Fedora VM boot hang; old index wrongly attributed this to vhost-user reconnection without evidence.
Begin at bugs/01_sqlite_wal_reset_checkpoint_race/START_HERE.txt.

Folders:
01_sqlite_wal_reset_checkpoint_race
02_kvm_mmu_cache_lifetime_reload
03_inotify_rename_cookie_coalescing
04_redis_srandmember_fork_hang
05_bcache_cpu_false_sharing
06_linux_gup_length_shift_overflow
07_ext4_big_endian_checksum_bytes
08_git_partial_write_contract
09_linux_ftrace_oversized_event_loop
10_otel_recursive_export_logging
11_bpftrace_lost_events_wrong_reporting
12_kvm_shadow_mmu_obsolete_root
13_ext4_inode_size_maxbytes_warning
14_cloud_hypervisor_fedora_boot_hang
15_sqlite_wal_header_sync_ordering
16_linux_bio_recursion_mempool_deadlock
17_inotify_watch_reference_race
18_linux_codel_mtu_floor_wrong_drop
19_ceph_rgw_bypass_gc_shared_object_data
20_ceph_osd_zero_timestamp_underflow

Prior research text: research/ORIGINAL_INDEX.txt and research/MASTER_PROMPT.txt.
Upstream source remains at links in each UPSTREAM.txt; kernel / project source trees are not copied or forked into this repository.