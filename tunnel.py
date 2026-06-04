"""
Chengdu Metro — Public Tunnel
Zero install. Uses SSH (built into Windows) + serveo.net
"""
import subprocess, sys, time, os

BASE = os.path.dirname(os.path.abspath(__file__))
os.chdir(BASE)

print("=" * 50)
print("  Chengdu Metro — Public Tunnel")
print("=" * 50)
print()

# 1. Start Flask
print("Starting Flask server...")
flask = subprocess.Popen(
    [sys.executable, "metro_app.py"],
    stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
)
time.sleep(3)

print("Flask: running on localhost:5000")
print()

# 2. SSH tunnel via serveo.net
print("Starting public tunnel (serveo.net)...")
print("=" * 50)
print("  Look for:  Forwarding HTTP traffic from")
print("  https://xxxx.serveo.net")
print()
print("  Copy that URL to your phone!")
print("  Press Ctrl+C to stop")
print("=" * 50)
print()

try:
    subprocess.run([
        "ssh", "-o", "StrictHostKeyChecking=accept-new",
        "-R", "80:localhost:5000", "serveo.net"
    ])
finally:
    flask.terminate()
    print()
    print("Server stopped.")
