import { Toaster } from "@/components/ui/toaster";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { TooltipProvider } from "@/components/ui/tooltip";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import Index from "./pages/Index";
import Onboarding from "./pages/Onboarding";
import Home from "./pages/Home";
import Routine from "./pages/Routine";
import Products from "./pages/Products";
import Nutrition from "./pages/Nutrition";
import Profile from "./pages/Profile";
import MobileLayout from "./components/MobileLayout";
import NotFound from "./pages/NotFound";
import DbAudit from "./pages/DbAudit";

const queryClient = new QueryClient();

const WithLayout = ({ children }: { children: React.ReactNode }) => (
  <MobileLayout>{children}</MobileLayout>
);

const App = () => (
  <QueryClientProvider client={queryClient}>
    <TooltipProvider>
      <Toaster />
      <Sonner />
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<Index />} />
          <Route path="/onboarding" element={<Onboarding />} />
          <Route path="/home" element={<WithLayout><Home /></WithLayout>} />
          <Route path="/routine" element={<WithLayout><Routine /></WithLayout>} />
          <Route path="/products" element={<WithLayout><Products /></WithLayout>} />
          <Route path="/nutrition" element={<WithLayout><Nutrition /></WithLayout>} />
          <Route path="/profile" element={<WithLayout><Profile /></WithLayout>} />
          <Route path="/db-audit" element={<DbAudit />} />
          <Route path="*" element={<NotFound />} />
        </Routes>
      </BrowserRouter>
    </TooltipProvider>
  </QueryClientProvider>
);

export default App;
