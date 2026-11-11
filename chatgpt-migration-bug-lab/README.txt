Migration bug study collection, created 2026-11-12.
Repository: https://github.com/learnrahulrai-ui/bugs-
Exactly 7 independently sourced cases below. Each case has BUG.txt and REPRO.txt.
No solution, fixed code, or patch contents are copied here.
W fields use numeric facts. Illustrative numbers are marked MODEL and never presented as observations.
Upstream-fix cases use the pre-fix parent commit when verified. A public report is not proof a bug remains open in November 2026.
Repository files are study instructions, not proof of local reproduction. NONE of these cases was executed in this session.
Every runnable hang test belongs in a disposable VM with a reset path. Never run a syzbot reproducer on the everyday host.
No unverified shell procedure is labeled an upstream reproducer. Certain cases depend on VFIO devices or vhost-user backends and have only a construction/test plan.

1. 01_linux_hugetlb_migration_punch_hole
   Linux hugetlb migration and MADV_REMOVE: hung tasks
   Confirmed upstream syzbot report; reproduced by syzbot, NOT executed here.
   https://syzkaller.appspot.com/bug?extid=2d9c96466c978346b55f

2. 02_qemu_vfio_region_del_dirty_bitmap
   QEMU VFIO listener: dirty memory omitted on region removal
   Confirmed from upstream January 2026 commit; no public standalone reproducer established; NOT executed here.
   https://lore.kernel.org/qemu-devel/20251218062643.624796-8-zhenzhong.duan@intel.com/

3. 03_qemu_iommufd_dirty_before_unmap
   QEMU VFIO iommufd: dirty-bit query order on DMA unmap
   Confirmed from upstream January 2026 commit; no public standalone reproducer established; NOT executed here.
   https://lore.kernel.org/qemu-devel/20251218062643.624796-3-zhenzhong.duan@intel.com/

4. 04_qemu_postcopy_vhost_user_request_count
   QEMU postcopy with vhost-user: remaining bytes zero but completion hangs
   Confirmed upstream hang; original report described 9 residual entries out of about 244000 page requests. NOT executed here.
   https://www.mail-archive.com/qemu-devel@nongnu.org/msg1218978.html

5. 05_qemu_multifd_postcopy_legacy_machine
   QEMU legacy pc-q35-7.2: multifd plus postcopy/preempt hang
   Confirmed upstream author supplied exact qtest reproducer. NOT executed here.
   https://www.mail-archive.com/qemu-devel@nongnu.org/msg1227109.html

6. 06_qemu_qmp_stop_during_postcopy_pause
   QEMU QMP stop request hangs in postcopy-paused state
   Public issue report with manual sequence; NOT executed here; issue status and current fix state require verification.
   https://gitlab.com/qemu-project/qemu/-/issues/1052

7. 07_xen_shadow_paging_host_dos
   Xen XSA-495: shadow paging can stall the host
   Official Xen security advisory. No public safe standalone reproducer verified; inspection-only; NOT executed here.
   https://xenbits.xenproject.org/xsa/advisory-495.html

Rule: First write your prediction, then run the test; capture logs, exact binaries, kernel/version, flags, page sizes, and success/failure.
Rule: For every test distinguish symptom reported upstream, observed locally, and numerical model.
Rule: Do not open upstream fix commits or patch hunks until you finish the QUESTIONS in BUG.txt.
