import { useNavigate } from "react-router";
import { Home, Search, Plus, MessageCircle, User } from "lucide-react";
import { C, font } from "../data";

type NavTab = "home" | "search" | "sell" | "chat" | "profile";

const tabs: { id: NavTab; label: string; icon: React.FC<{ size: number; color: string }>; path: string }[] = [
  { id: "home",    label: "Home",    icon: ({ size, color }) => <Home size={size} color={color} strokeWidth={1.7} />,          path: "/" },
  { id: "search",  label: "Search",  icon: ({ size, color }) => <Search size={size} color={color} strokeWidth={1.7} />,        path: "/search" },
  { id: "sell",    label: "Sell",    icon: ({ size, color }) => <Plus size={size} color={color} strokeWidth={1.7} />,           path: "/sell" },
  { id: "chat",    label: "Chat",    icon: ({ size, color }) => <MessageCircle size={size} color={color} strokeWidth={1.7} />, path: "/messages" },
  { id: "profile", label: "Profile", icon: ({ size, color }) => <User size={size} color={color} strokeWidth={1.7} />,          path: "/profile" },
];

export function BottomNav({ active }: { active: NavTab }) {
  const navigate = useNavigate();
  return (
    <div
      className="flex-shrink-0 flex items-center justify-between px-8"
      style={{
        background: C.base,
        height: 80,
        borderTop: `1px solid ${C.border}`,
      }}
    >
      {tabs.map((tab) => {
        const isActive = tab.id === active;
        const IconColor = isActive ? C.base : C.espresso;
        return (
          <button
            key={tab.id}
            onClick={() => navigate(tab.path)}
            className="flex flex-col items-center gap-1"
            style={{ minWidth: 36 }}
          >
            <div
              className="flex items-center justify-center rounded-[14px]"
              style={{
                width: 36, height: 36,
                background: isActive ? C.gold : "transparent",
              }}
            >
              <tab.icon size={20} color={isActive ? C.base : C.espresso} />
            </div>
            <span
              style={{
                fontFamily: font.family,
                fontSize: 10,
                color: isActive ? C.gold : C.mocha,
                letterSpacing: "0.117px",
              }}
            >
              {tab.label}
            </span>
          </button>
        );
      })}
    </div>
  );
}
