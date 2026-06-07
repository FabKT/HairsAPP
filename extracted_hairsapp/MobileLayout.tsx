import { useLocation, useNavigate } from "react-router-dom";
import { Home, Calendar, ShoppingBag, Apple, User } from "lucide-react";

const tabs = [
  { path: "/home", icon: Home, label: "Home" },
  { path: "/routine", icon: Calendar, label: "Routine" },
  { path: "/products", icon: ShoppingBag, label: "Products" },
  { path: "/nutrition", icon: Apple, label: "Nutrition" },
  { path: "/profile", icon: User, label: "Profile" },
];

const MobileLayout = ({ children }: { children: React.ReactNode }) => {
  const location = useLocation();
  const navigate = useNavigate();

  return (
    <div className="relative mx-auto min-h-screen max-w-[430px] bg-background">
      <main className="pb-24 safe-area-top">{children}</main>
      <nav className="fixed bottom-0 left-1/2 z-50 w-full max-w-[430px] -translate-x-1/2 border-t border-border/50 bg-background/80 backdrop-blur-xl safe-area-bottom">
        <div className="flex items-center justify-around px-2 pt-1.5 pb-1">
          {tabs.map((tab) => {
            const isActive = location.pathname === tab.path;
            return (
              <button
                key={tab.path}
                onClick={() => navigate(tab.path)}
                className={`flex flex-col items-center gap-0.5 py-1 transition-all ${
                  isActive ? "text-accent" : "text-muted-foreground"
                }`}
              >
                <div className={`flex h-9 w-9 items-center justify-center rounded-2xl transition-all ${
                  isActive ? "gradient-primary" : ""
                }`}>
                  <tab.icon className="h-5 w-5" />
                </div>
                <span className="text-[10px] font-medium">{tab.label}</span>
              </button>
            );
          })}
        </div>
      </nav>
    </div>
  );
};

export default MobileLayout;
