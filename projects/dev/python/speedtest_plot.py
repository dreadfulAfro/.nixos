import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv("/home/angelo/speedtest.csv", names=["time", "server name","server id","idle latency","idle jitter","packet loss","download","upload","download bytes","upload bytes","share url","download server count","download latency","download latency jitter","download latency low","download latency high","upload latency","upload latency jitter","upload latency low","upload latency high","idle latency low","idle latency high"])

plt.plot(df["time"], df["download"]*8/1000000)
plt.plot(df["time"], df["upload"]*8/1000000)
plt.xlabel("Time")
plt.ylabel("Download (Mbps)")
plt.show()