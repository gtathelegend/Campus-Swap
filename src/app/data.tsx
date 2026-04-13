import imgParallelBar from "figma:asset/dbcac6e943ea59a567bce174d91e1376a8522cb6.png";
import imgDeskLamp from "figma:asset/fbbf31714dca13783031c134e059c8b43585bd29.png";
import imgWinterCoat from "figma:asset/f333ce9e2e2942afa541a0e4891a06e2b6074b09.png";
import imgUsbCable from "figma:asset/e141eab01d14007da1eccfc779dc1e1aae65f6f4.png";
import imgMechPencils from "figma:asset/6d0aa10d69a20ce5fd7111788bb4fc9072ac61ac.png";
import imgUsbDrive from "figma:asset/5948afe811cf73a01789ebf60864037c051cd8cd.png";
import imgLaptop from "figma:asset/cd55980bc7994bcc321b2312d00857e13b914299.png";
import imgAcrylic from "figma:asset/ec8e657576178b61bbfcf25ef3c881c4befcbc48.png";

// ── Design Tokens ──────────────────────────────────────────────────────────
export const C = {
  espresso: "#4B3621",
  mocha: "#7E6D57",
  stone: "#9B8B7E",
  gold: "#D4AF37",
  alert: "#E54C4C",
  cream: "#F7F2E7",
  base: "#FFFFFF",
  border: "#E8DCC8",
};
export const shadow = {
  card: "0px 1px 3px 0px rgba(0,0,0,0.1), 0px 1px 2px 0px rgba(0,0,0,0.1)",
  button: "0px 4px 6px 0px rgba(0,0,0,0.1), 0px 2px 4px 0px rgba(0,0,0,0.1)",
  input: "0px 1px 3px 0px rgba(0,0,0,0.1), 0px 1px 2px -1px rgba(0,0,0,0.1)",
};
export const font = { family: "'Inter', sans-serif", display: "'Manrope', sans-serif" };

// ── Types ──────────────────────────────────────────────────────────────────
export interface Seller {
  id: string; name: string; rating: number; reviews: number;
  listings: number; sold: number; verified: boolean;
}
export interface Product {
  id: string; name: string; price: number; currency: string;
  condition: "New" | "Like New" | "Good" | "Fair";
  image: string; category: string; seller: Seller;
  location: string; description: string;
}
export interface Message { id: string; from: "me" | "them"; text: string; time: string; }
export interface Conversation { id: string; seller: Seller; lastMessage: string; messages: Message[]; }

// ── Sellers ────────────────────────────────────────────────────────────────
export const sellers: Seller[] = [
  { id: "sarah", name: "Sarah Johnson", rating: 4.8, reviews: 12, listings: 24, sold: 18, verified: true },
  { id: "mike",  name: "Mike Chen",     rating: 4.5, reviews: 8,  listings: 12, sold: 9,  verified: true },
  { id: "emma",  name: "Emma Davis",    rating: 4.9, reviews: 20, listings: 30, sold: 25, verified: true },
  { id: "alex",  name: "Alex Turner",   rating: 4.3, reviews: 5,  listings: 8,  sold: 6,  verified: false },
  { id: "lisa",  name: "Lisa Park",     rating: 4.7, reviews: 15, listings: 18, sold: 14, verified: true },
];

// ── Products ───────────────────────────────────────────────────────────────
export const products: Product[] = [
  { id: "parallel-bar", name: "Parellel Bar", price: 250, currency: "₹", condition: "Like New", image: imgParallelBar, category: "Books",   seller: sellers[0], location: "South Campus", description: "Barely used calculus textbook. Great condition with no markings. Perfect for MATH 101 students." },
  { id: "desk-lamp",    name: "Desk Lamp",    price: 850, currency: "₹", condition: "Good",     image: imgDeskLamp,    category: "Tech",    seller: sellers[1], location: "North Campus", description: "Adjustable LED desk lamp, perfect for late-night studying. Minor scratch on base, fully functional." },
  { id: "winter-coat",  name: "Winter Coat",  price: 600, currency: "₹", condition: "Good",     image: imgWinterCoat,  category: "Fashion", seller: sellers[2], location: "East Campus",  description: "Warm black winter coat, size M. Worn one semester. Excellent insulation for cold campus days." },
  { id: "usb-c-cable",  name: "USB-C Cable",  price: 150, currency: "₹", condition: "New",      image: imgUsbCable,    category: "Tech",    seller: sellers[3], location: "South Campus", description: "Brand new USB-C to USB-C cable, 2m length. Fast charging compatible. Still in original packaging." },
  { id: "mech-pencils", name: "Mechanical Pencils", price: 30, currency: "$", condition: "New",  image: imgMechPencils, category: "Books",   seller: sellers[0], location: "Library",       description: "Set of 10 mechanical pencils, 0.5mm. Brand new, still in packaging." },
  { id: "usb-drive",    name: "USB Drive",    price: 22, currency: "$",  condition: "Like New", image: imgUsbDrive,    category: "Tech",    seller: sellers[1], location: "Tech Center",  description: "64GB USB 3.0 flash drive. Very fast transfer speeds. Barely used." },
  { id: "laptop",       name: "Laptop",       price: 28, currency: "$",  condition: "Good",     image: imgLaptop,      category: "Tech",    seller: sellers[2], location: "West Campus",  description: "Dell laptop, i5 processor, 8GB RAM. Good for coursework." },
  { id: "acrylic-colors", name: "Acrylic Colors", price: 18, currency: "$", condition: "New",   image: imgAcrylic,     category: "Books",   seller: sellers[3], location: "Art Building", description: "Set of 24 acrylic paint tubes. Perfect for art class projects." },
  // Seller listings (for SellerProfile)
  { id: "seller-lamp",  name: "Desk Lamp",    price: 15, currency: "$",  condition: "Good",     image: imgDeskLamp,    category: "Tech",    seller: sellers[0], location: "South Campus", description: "Good condition desk lamp." },
  { id: "seller-coat",  name: "Winter Coat",  price: 40, currency: "$",  condition: "Good",     image: imgWinterCoat,  category: "Fashion", seller: sellers[0], location: "South Campus", description: "Warm winter coat, size M." },
  { id: "notebook-set", name: "Notebook Set", price: 8,  currency: "$",  condition: "New",      image: imgMechPencils, category: "Books",   seller: sellers[0], location: "South Campus", description: "Set of 5 spiral notebooks, never used." },
  { id: "calculator",   name: "Calculator",   price: 20, currency: "$",  condition: "New",      image: imgUsbDrive,    category: "Tech",    seller: sellers[0], location: "South Campus", description: "Scientific calculator, TI-84, good for engineering." },
];

export const sellerProducts = (sellerId: string) => products.filter(p => p.seller.id === sellerId);

// ── Electronics category (no real images, handled in Category page) ────────
export const electronicsProducts = [
  { id: "macbook-charger", name: "MacBook Charger", price: 30, currency: "$", condition: "New",      seller: sellers[0] },
  { id: "wireless-mouse",  name: "Wireless Mouse",  price: 12, currency: "$", condition: "Like New", seller: sellers[1] },
  { id: "usb-hub",         name: "USB Hub",         price: 18, currency: "$", condition: "Good",     seller: sellers[2] },
  { id: "hdmi-cable",      name: "HDMI Cable",      price: 8,  currency: "$", condition: "Like New", seller: sellers[3] },
  { id: "keyboard",        name: "Keyboard",        price: 25, currency: "$", condition: "Like New", seller: sellers[4] },
  { id: "webcam",          name: "Webcam",          price: 35, currency: "$", condition: "New",      seller: sellers[0] },
];

// ── Conversations ─────────────────────────────────────────────────────────
export const conversations: Conversation[] = [
  { id: "sarah", seller: sellers[0], lastMessage: "Is the textbook still available?",
    messages: [
      { id: "1", from: "them", text: "Hi! Is the calculus textbook still available?", time: "10:30 AM" },
      { id: "2", from: "me",   text: "Yes, it's still available!", time: "10:32 AM" },
      { id: "3", from: "them", text: "Great! Can we meet tomorrow at the library?", time: "10:33 AM" },
      { id: "4", from: "me",   text: "Sure! 2 PM works for me", time: "10:35 AM" },
    ]
  },
  { id: "mike", seller: sellers[1], lastMessage: "Can we meet tomorrow?",
    messages: [
      { id: "1", from: "them", text: "Hey, is the desk lamp still for sale?", time: "9:00 AM" },
      { id: "2", from: "me",   text: "Yes it is! It's in great condition.", time: "9:05 AM" },
      { id: "3", from: "them", text: "Can we meet tomorrow?", time: "9:10 AM" },
    ]
  },
  { id: "emma", seller: sellers[2], lastMessage: "Thanks for the quick response!",
    messages: [
      { id: "1", from: "me",   text: "The coat is available, interested?", time: "8:00 AM" },
      { id: "2", from: "them", text: "Thanks for the quick response!", time: "8:05 AM" },
    ]
  },
  { id: "alex", seller: sellers[3], lastMessage: "I'm interested in the desk lamp",
    messages: [
      { id: "1", from: "them", text: "I'm interested in the desk lamp", time: "Yesterday" },
    ]
  },
  { id: "lisa", seller: sellers[4], lastMessage: "What's the condition?",
    messages: [
      { id: "1", from: "them", text: "What's the condition?", time: "Yesterday" },
    ]
  },
];

export const categories = [
  { id: "books",     name: "Books"     },
  { id: "tech",      name: "Tech"      },
  { id: "fashion",   name: "Fashion"   },
  { id: "bikes",     name: "Bikes"     },
  { id: "furniture", name: "Furniture" },
];
