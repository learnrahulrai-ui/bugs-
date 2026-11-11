Real open-source bug study archive.

A directory under bugs/ is a sourced issue investigation, not proof of a successful reproduction or of a still-open upstream defect. Collections and labs are not standalone bugs.

First follow the numbered steps in a bug folder. A new term must be established before its first use. Track the first incorrect assumption, then connect it to the exact user-visible failure. Preserve exact source files, line numbers, commit versions, inputs, and observed outputs.

The research/Linux_interview_real_bugs_459_questions.txt file indexes 459 interview questions against 35 earlier research cases. Matching several questions to one defect does not create 459 independent verified bugs.

A ZIP of the same complete research text is stored as research/Linux_interview_real_bugs_459_questions.zip. GitHub's Download ZIP also includes all current study folders.

Run status is documented in research/REPRO_STATUS.txt. REPORTED means claimed in upstream issue. REPRODUCED_HERE means tested in the local sandbox. UNTESTED_HERE means no local reproduction was run. Tests on this sandbox are not tests on the user's laptop.

Never use a production storage device to reproduce a trim, filesystem corruption, mount, or kernel crash issue. Use an isolated VM and disposable file-backed disk.

Upstream issue authors and projects retain rights in original code. These files provide new investigations and links, not copies of whole upstream source files.
