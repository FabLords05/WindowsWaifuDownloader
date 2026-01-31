import tkinter as tk
from tkinter import ttk, messagebox, filedialog
from PIL import Image, ImageTk
import io
import threading
from src.waifu import WaifuDownloaderAPI  # Make sure waifu.py is in a 'src' folder or adjust import

class WindowsWaifuApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Waifu Downloader (Windows Edition)")
        self.root.geometry("450x600")
        
        # Initialize the API from your existing file
        self.api = WaifuDownloaderAPI()
        self.current_image_bytes = None
        self.current_extension = "png" # default
        self.current_id = "unknown"

        # UI Setup
        self.setup_ui()
        
        # Load first image
        self.reload_image_async()

    def setup_ui(self):
        # Image Display Area
        self.image_label = tk.Label(self.root, text="Loading...", bg="#333", fg="white")
        self.image_label.pack(expand=True, fill="both", padx=10, pady=10)

        # Controls Frame
        controls = ttk.Frame(self.root)
        controls.pack(fill="x", padx=10, pady=10)

        # Refresh Button
        self.btn_refresh = ttk.Button(controls, text="New Waifu", command=self.reload_image_async)
        self.btn_refresh.pack(side="left", expand=True, fill="x", padx=5)

        # Save Button
        self.btn_save = ttk.Button(controls, text="Save Image", command=self.save_image)
        self.btn_save.pack(side="left", expand=True, fill="x", padx=5)

    def reload_image_async(self):
        # Disable buttons while loading
        self.btn_refresh.config(state="disabled")
        self.image_label.config(text="Fetching...")
        
        # Run in thread so the window doesn't freeze
        thread = threading.Thread(target=self._fetch_image)
        thread.daemon = True
        thread.start()

    def _fetch_image(self):
        try:
            # Using the method from your src/waifu.py
            url = self.api.get_neko(nsfw=False) 
            if not url:
                raise Exception("API returned nothing")
            
            # Save metadata for saving later
            if hasattr(self.api, 'info') and self.api.info:
                 img_data = self.api.info["images"][0]
                 self.current_extension = img_data["extension"]
                 self.current_id = img_data["image_id"]

            # Download the actual image bytes
            image_content = self.api.get_image(url)
            self.current_image_bytes = image_content

            # Update UI on main thread
            self.root.after(0, lambda: self._update_image_display(image_content))
            
        except Exception as e:
            print(f"Error: {e}")
            self.root.after(0, lambda: self.btn_refresh.config(state="normal"))

    def _update_image_display(self, image_data):
        try:
            # Convert bytes to an image Tkinter can understand
            image = Image.open(io.BytesIO(image_data))
            
            # Resize to fit window height strictly (keeping aspect ratio)
            base_height = 450
            h_percent = (base_height / float(image.size[1]))
            w_size = int((float(image.size[0]) * float(h_percent)))
            image = image.resize((w_size, base_height), Image.Resampling.LANCZOS)
            
            photo = ImageTk.PhotoImage(image)
            
            self.image_label.config(image=photo, text="")
            self.image_label.image = photo # Keep reference!
        except Exception as e:
            self.image_label.config(text=f"Failed to load image: {e}")
        finally:
            self.btn_refresh.config(state="normal")

    def save_image(self):
        if not self.current_image_bytes:
            messagebox.showerror("Error", "No image to save!")
            return

        filename = filedialog.asksaveasfilename(
            defaultextension=self.current_extension,
            initialfile=f"waifu_{self.current_id}{self.current_extension}",
            filetypes=[("Images", f"*{self.current_extension}"), ("All Files", "*.*")]
        )
        
        if filename:
            with open(filename, "wb") as f:
                f.write(self.current_image_bytes)
            messagebox.showinfo("Success", "Waifu acquired.")

if __name__ == "__main__":
    root = tk.Tk()
    app = WindowsWaifuApp(root)
    root.mainloop()