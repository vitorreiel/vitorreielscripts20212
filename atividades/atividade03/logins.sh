# Correção: 2,0
# 1. Comando
grep -v "sshd" auth.log
# 2. Comando
grep -E "sshd.*for j" auth.log
# 3. Comando
grep -E "sshd.*root" auth.log
# 4. Comando
grep -E "Oct 1[1-2].*Accepted" auth.log
