# 1. Comando
grep -v "sshd" auth.log
# 2. Comando
grep -E "sshd:session.*user j" auth.log
# 3. Comando
grep -E "sshd.*root" auth.log
# 4. Comando
grep -E "Oct 1[1-2].*:session" auth.log
