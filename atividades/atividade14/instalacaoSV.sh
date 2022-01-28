#!/bin/bash

sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo touch /var/www/html/texto.html
sudo chown ec2-user /var/www/html/texto.html

echo "*/1 * * * * ec2-user /home/ec2-user/monitoramento.sh" >> /etc/crontab

echo "<html>
        <head>
        <title>Atividade 14</title>
                <style>
                        #i{
                                width: 25%;
                                height: 80%;
                                border: 3px solid #ccc;
                                border-radius: 20px;
                                margin-top: 5%;
                                margin-left: 36%;
                                background-color: white;
                                padding-left: 40px;
                        }
                        body{
                                background-image: linear-gradient(to bottom, white, #CFFFE5, #C2E5D3);
                        }
                </style>
        </head>
        <body>
                <div>
                        <iframe src='texto.html' id='i'></iframe>
                </div>
        </body>
</html>" > /var/www/html/index.html
cat <<EOF > /home/ec2-user/monitoramento.sh
#!/bin/bash
        DATA=\$(date +%H:%M:%S-%D)
        TEMP=\$(uptime | sed 's/:[0-9][0-9] /\n/g;s/  /\n/g' | head -2 | tail -1)
        CMS=\$(uptime | sed 's/  /\n/g' | head -4 | tail -1)
        MEML=\$(free | head -2 | tail -1 | egrep -o '\w+' | head -4 | tail -1)
        MEMU=\$(free | head -2 | tail -1 | egrep -o '\w+' | head -3 | tail -1)
        BYT=\$(cat /proc/net/dev | tail -1 | egrep -o '\w+' | head -2 | tail -1)
        TRN=\$(cat /proc/net/dev | tail -1 | egrep -o '\w+' | head -10 | tail -1)
        echo -e '<h2>'\$DATA '<br>\n'\$TEMP '<br>\n'\$CMS '<br>\nMemória livre: '\$MEML ', ocupada: '\$MEMU '<br>\nBytes recebidos: '\$BYT ', enviados: '\$TRN '<br>\n<hr width="50%" color="#ccc"></hr>\n' > /var/www/html/texto.html
EOF
sudo chmod +x /home/ec2-user/monitoramento.sh
