import { createBrowserRouter } from "react-router";
import Home from "./pages/Home";
import Search from "./pages/Search";
import Filters from "./pages/Filters";
import Category from "./pages/Category";
import ProductDetail from "./pages/ProductDetail";
import SellerProfile from "./pages/SellerProfile";
import ReportListing from "./pages/ReportListing";
import Messages from "./pages/Messages";
import Chat from "./pages/Chat";
import Sell from "./pages/Sell";
import Profile from "./pages/Profile";

export const mainRouter = createBrowserRouter([
  { path: "/",              Component: Home         },
  { path: "/search",        Component: Search       },
  { path: "/filters",       Component: Filters      },
  { path: "/category/:name",Component: Category     },
  { path: "/product/:id",   Component: ProductDetail},
  { path: "/seller/:id",    Component: SellerProfile},
  { path: "/report/:type",  Component: ReportListing},
  { path: "/messages",      Component: Messages     },
  { path: "/chat/:id",      Component: Chat         },
  { path: "/sell",          Component: Sell         },
  { path: "/profile",       Component: Profile      },
  { path: "*",              Component: Home         },
]);
