#!/usr/bin/env python3
import time
from datetime import datetime

while True:
	print(f"{datetime.now().isoformat()} - monitor ativo", flush=True)
	time.sleep(5)
