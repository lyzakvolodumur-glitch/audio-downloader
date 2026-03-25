@echo off
echo Downloading everything...
pip install telethon pyinstaller

echo Creating app...

echo import os > app.py
echo import json >> app.py
echo import tkinter as tk >> app.py
echo from tkinter import filedialog, messagebox >> app.py
echo from telethon import TelegramClient >> app.py
echo import threading >> app.py

echo CONFIG_FILE = "config.json" >> app.py
echo PROGRESS_FILE = "progress.json" >> app.py

echo def load_config(): >> app.py
echo     if os.path.exists(CONFIG_FILE): return json.load(open(CONFIG_FILE)) >> app.py
echo     return {} >> app.py

echo def save_config(api_id, api_hash): >> app.py
echo     json.dump({"api_id": api_id, "api_hash": api_hash}, open(CONFIG_FILE, "w")) >> app.py

echo def load_progress(): >> app.py
echo     if os.path.exists(PROGRESS_FILE): return json.load(open(PROGRESS_FILE)) >> app.py
echo     return {"last_id": 0} >> app.py

echo def save_progress(last_id): >> app.py
echo     json.dump({"last_id": last_id}, open(PROGRESS_FILE, "w")) >> app.py

echo def download(): >> app.py
echo     try: >> app.py
echo         api_id = int(entry_id.get()) >> app.py
echo         api_hash = entry_hash.get() >> app.py
echo         channel = entry_channel.get() >> app.py
echo         path = folder_path.get() >> app.py

echo         if not path: >> app.py
echo             messagebox.showerror("Error", "Select folder!") >> app.py
echo             return >> app.py

echo         save_config(api_id, api_hash) >> app.py
echo         progress = load_progress() >> app.py
echo         last_id = progress.get("last_id", 0) >> app.py

echo         os.makedirs(path, exist_ok=True) >> app.py
echo         client = TelegramClient("session", api_id, api_hash) >> app.py
echo         client.start() >> app.py

echo         count = 0 >> app.py
echo         new_last_id = last_id >> app.py

echo         for m in client.iter_messages(channel, min_id=last_id): >> app.py
echo             if m.audio: >> app.py
echo                 client.download_media(m, file=path) >> app.py
echo                 count += 1 >> app.py
echo             if m.id > new_last_id: new_last_id = m.id >> app.py

echo         save_progress(new_last_id) >> app.py
echo         messagebox.showinfo("Done", f"Downloaded: {count}") >> app.py

echo     except Exception as e: >> app.py
echo         messagebox.showerror("Error", str(e)) >> app.py

echo def browse(): >> app.py
echo     folder_path.set(filedialog.askdirectory()) >> app.py

echo root = tk.Tk() >> app.py
echo root.title("Telegram Downloader") >> app.py
echo root.geometry("400x350") >> app.py

echo config = load_config() >> app.py

echo tk.Label(root, text="API ID").pack() >> app.py
echo entry_id = tk.Entry(root) >> app.py
echo entry_id.pack() >> app.py
echo entry_id.insert(0, config.get("api_id","")) >> app.py

echo tk.Label(root, text="API HASH").pack() >> app.py
echo entry_hash = tk.Entry(root) >> app.py
echo entry_hash.pack() >> app.py
echo entry_hash.insert(0, config.get("api_hash","")) >> app.py

echo tk.Label(root, text="Channel").pack() >> app.py
echo entry_channel = tk.Entry(root) >> app.py
echo entry_channel.pack() >> app.py

echo folder_path = tk.StringVar() >> app.py
echo tk.Button(root, text="Select Folder", command=browse).pack() >> app.py

echo tk.Button(root, text="START", command=lambda: threading.Thread(target=download).start()).pack(pady=10) >> app.py

echo root.mainloop() >> app.py

echo Building EXE...
pyinstaller --onefile --noconsole app.py

echo DONE!
pause