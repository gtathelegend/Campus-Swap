import { useNavigate } from "react-router";
import { ChevronRight, Star, Package, Heart, Settings, LogOut } from "lucide-react";
import { C, font, shadow } from "../data";
import { BottomNav } from "../components/BottomNav";

const menuItems = [
  { icon: Package, label: "My Listings",   path: "/search"  },
  { icon: Heart,   label: "Saved Items",   path: "/search"  },
  { icon: Settings,label: "Settings",      path: "/profile" },
];

export default function Profile() {
  const navigate = useNavigate();

  return (
    <div className="flex flex-col h-full" style={{ background: C.cream }}>
      {/* Header */}
      <div
        className="flex-shrink-0 flex items-center px-4"
        style={{ background: C.base, height: 63, borderBottom: `1px solid ${C.border}` }}
      >
        <span style={{ fontFamily: font.family, fontSize: 20, fontWeight: 500, color: C.espresso, letterSpacing: "-0.449px" }}>
          Profile
        </span>
      </div>

      <div className="flex-1 overflow-y-auto">
        {/* Profile hero */}
        <div
          className="flex flex-col items-center gap-3 py-8 px-4"
          style={{ background: C.base, borderBottom: `1px solid ${C.border}` }}
        >
          <div className="rounded-full" style={{ width: 80, height: 80, background: C.border }} />
          <div className="flex flex-col items-center gap-1">
            <span style={{ fontFamily: font.family, fontSize: 18, fontWeight: 500, color: C.espresso }}>
              You
            </span>
            <span style={{ fontFamily: font.family, fontSize: 14, color: C.mocha }}>student@university.edu</span>
          </div>
          <div className="flex items-center gap-1">
            <Star size={14} color={C.gold} fill={C.gold} />
            <span style={{ fontFamily: font.family, fontSize: 14, color: C.mocha }}>4.7 · 8 reviews</span>
          </div>
          <div
            className="flex items-center justify-center rounded-full px-4"
            style={{ height: 30, background: `${C.gold}22` }}
          >
            <span style={{ fontFamily: font.family, fontSize: 14, color: C.gold }}>Verified Student</span>
          </div>
        </div>

        {/* Stats */}
        <div
          className="flex"
          style={{ background: C.base, height: 80, borderBottom: `1px solid ${C.border}` }}
        >
          {[{ value: "5", label: "Listings" }, { value: "3", label: "Sold" }, { value: "8", label: "Reviews" }].map((s, i) => (
            <div key={s.label} className="flex-1 flex flex-col items-center justify-center gap-1"
              style={{ borderLeft: i > 0 ? `1px solid ${C.border}` : "none" }}>
              <span style={{ fontFamily: font.family, fontSize: 16, color: C.espresso }}>{s.value}</span>
              <span style={{ fontFamily: font.family, fontSize: 14, color: C.mocha }}>{s.label}</span>
            </div>
          ))}
        </div>

        {/* Menu items */}
        <div className="p-4 flex flex-col gap-3">
          {menuItems.map((item) => (
            <button
              key={item.label}
              onClick={() => navigate(item.path)}
              className="w-full flex items-center gap-3 rounded-2xl px-4"
              style={{ background: C.base, height: 58, border: `1px solid ${C.border}`, boxShadow: shadow.card }}
            >
              <item.icon size={20} color={C.mocha} strokeWidth={1.7} />
              <span className="flex-1 text-left" style={{ fontFamily: font.family, fontSize: 16, color: C.espresso, letterSpacing: "-0.3125px" }}>
                {item.label}
              </span>
              <ChevronRight size={18} color={C.mocha} strokeWidth={1.7} />
            </button>
          ))}

          {/* Logout */}
          <button
            className="w-full flex items-center gap-3 rounded-2xl px-4 mt-2"
            style={{ background: `${C.alert}11`, height: 58, border: `1px solid ${C.alert}33` }}
          >
            <LogOut size={20} color={C.alert} strokeWidth={1.7} />
            <span style={{ fontFamily: font.family, fontSize: 16, color: C.alert, letterSpacing: "-0.3125px" }}>
              Log Out
            </span>
          </button>
        </div>
      </div>

      <BottomNav active="profile" />
    </div>
  );
}
