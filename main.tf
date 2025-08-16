##############################
# EC2 Instance
##############################
resource "aws_instance" "devops_instance" {
  ami                  = var.instance_ami
  instance_type        = var.instance_type
  key_name             = var.key_name
  iam_instance_profile = aws_iam_instance_profile.readonly_instance_profile.name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y aws-cli git java-19-amazon-corretto-devel

              # Clone repo and start app
              git clone https://github.com/techeazy-consulting/techeazy-devops.git /home/ec2-user/app
              cd /home/ec2-user/app
              ./start.sh

              # Copy upload script
              cat << 'SCRIPT' > /usr/local/bin/upload-logs.sh
              #!/bin/bash
              BUCKET_NAME="${var.bucket_name}-${var.stage}"
              aws s3 cp /var/log/cloud-init.log s3://$BUCKET_NAME/logs/cloud-init.log
              if [ -d "/home/ec2-user/app/logs/" ]; then
                aws s3 cp /home/ec2-user/app/logs/ s3://$BUCKET_NAME/app/logs/ --recursive
              fi
              SCRIPT
              chmod +x /usr/local/bin/upload-logs.sh

              # Create systemd service to upload logs on shutdown
              echo "[Unit]
              Description=Upload logs to S3 on shutdown
              DefaultDependencies=no
              Before=shutdown.target

              [Service]
              Type=oneshot
              ExecStart=/usr/local/bin/upload-logs.sh
              RemainAfterExit=yes

              [Install]
              WantedBy=halt.target reboot.target shutdown.target" > /etc/systemd/system/upload-logs.service

              systemctl enable upload-logs.service
              EOF

  tags = {
    Name = "DevOpsInstance-${var.stage}"
  }
}
