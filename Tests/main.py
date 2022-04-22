import boto3
import os
import unittest
import requests
from bs4 import BeautifulSoup
from paramiko import AutoAddPolicy, SSHClient


class Test(unittest.TestCase):
    instance = None
    instance_name = 'DevTestSecOps'
    tags_list = ['Date_creation', 'OS_type', 'Your_First_Name', 'Your_Last_Name', 'AWS_Account_ID']

    """
    Check that instance was created.
    """
    def setUp(self):
        if not self.instance:
            ec2 = boto3.resource('ec2', region_name='us-east-1')
            instances = ec2.instances.filter(
                Filters=[
                    {
                        'Name': 'tag:Name', 'Values': [self.instance_name]
                    },
                    {
                        'Name': 'instance-state-name', 'Values': ['running']
                    }
                ]
            )
            for instance in instances:
                self.instance = instance
            self.assertTrue(instance.id)

    """
    Check that instance has all tags assigned.
    """
    def test_tags(self):
        instance_tags = []
        for tag in self.instance.tags:
            instance_tags.append(tag["Key"])
        for tag in self.tags_list:
            self.assertIn(tag, instance_tags)
        print('Tags OK')

    """
    Check that it’s possible to connect to the instance over SSH.
    Check that index.html file has no executable bit.
    -
    ssh connect and execute
    """
    def test_ssh(self):
        ssh = SSHClient()
        ssh.set_missing_host_key_policy(AutoAddPolicy())
        ssh.connect(self.instance.public_dns_name, username='ec2-user',
                    key_filename=os.path.join(os.curdir, '.ssh', 'ec2-key'))
        print('SSH connect OK')
        (stdin, stdout, stderr) = ssh.exec_command(
            'if [[ -x /var/www/html/index.html ]]; then echo ERROR; else echo OK; fi')

        output = stdout.readlines()
        output = os.linesep.join(output).replace('\n', '')
        err = stderr.readlines()
        if err:
            print(os.linesep.join(err))
        ssh.close()
        self.assertIn('OK', output)
        print('File OK')

    """
    Check that it’s possible to access Apache site over HTTP from whitelisted IP address
    -
    Get page. Find fixed ID
    """
    def test_page(self):
        page = BeautifulSoup(requests.get('http://' + self.instance.public_dns_name).text, 'html.parser')
        element = page.find(id=self.instance_name)
        self.assertTrue(element)
        print('Page OK')

    """
    Check that it’s impossible to access Apache site over HTTP from not-whitelisted IP address
    -
    Using proxy
    """
    def test_page_proxy(self):
        try:
            page = BeautifulSoup(requests.get('http://' + self.instance.public_dns_name,
                                              proxies={'http': 'http://18.140.166.66:8080'}).text, 'html.parser')
            element = page.find(id=self.instance_name)
            self.assertTrue(False)
        except requests.exceptions.ConnectTimeout:
            self.assertTrue(True)
        print('Page OK')


if __name__ == '__main__':
    unittest.main()
