"use client";
import { useState, useEffect, useMemo } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Calendar, Users, TrendingUp, Wallet, Search, Menu, X, Activity } from "lucide-react";

interface Match {
  id: string; date: string; time: string; team1: string; team2: string;
  stage: "group" | "knockout" | "final"; group?: string; venue: string;
}
interface Team { id: string; name: string; flag: string; group: string; rank?: number; }
interface Market {
  id: string; question: string; yesPrice: number; noPrice: number;
  volume: number; endDate: string; category: string;
}

const MATCHES: Match[] = [
  { id: "1", date: "June 11, 2026", time: "17:00", team1: "Mexico", team2: "Canada", stage: "group", group: "A", venue: "Mexico City" },
  { id: "2", date: "June 11, 2026", time: "20:00", team1: "USA", team2: "TBD", stage: "group", group: "A", venue: "Los Angeles" },
  { id: "3", date: "June 12, 2026", time: "14:00", team1: "Argentina", team2: "TBD", stage: "group", group: "C", venue: "New York" },
  { id: "4", date: "June 12, 2026", time: "17:00", team1: "Brazil", team2: "TBD", stage: "group", group: "D", venue: "Miami" },
  { id: "5", date: "June 13, 2026", time: "15:00", team1: "France", team2: "TBD", stage: "group", group: "A", venue: "Toronto" },
  { id: "6", date: "June 14, 2026", time: "15:00", team1: "Germany", team2: "TBD", stage: "group", group: "B", venue: "Boston" },
  { id: "7", date: "June 15, 2026", time: "17:00", team1: "Spain", team2: "TBD", stage: "group", group: "C", venue: "Philadelphia" },
  { id: "8", date: "June 16, 2026", time: "15:00", team1: "England", team2: "TBD", stage: "group", group: "B", venue: "Chicago" },
  { id: "9", date: "July 3, 2026", time: "15:00", team1: "QF1", team2: "QF2", stage: "knockout", venue: "Seattle" },
  { id: "10", date: "July 10, 2026", time: "18:00", team1: "SF1", team2: "SF2", stage: "knockout", venue: "Atlanta" },
  { id: "11", date: "July 19, 2026", time: "17:00", team1: "Winner SF1", team2: "Winner SF2", stage: "final", venue: "New York" },
];

const TEAMS: Team[] = [
  { id: "mex", name: "Mexico", flag: "🇲🇽", group: "A", rank: 12 },
  { id: "can", name: "Canada", flag: "🇨🇦", group: "A", rank: 38 },
  { id: "usa", name: "USA", flag: "🇺🇸", group: "A", rank: 16 },
  { id: "arg", name: "Argentina", flag: "🇦🇷", group: "C", rank: 1 },
  { id: "bra", name: "Brazil", flag: "🇧🇷", group: "D", rank: 3 },
  { id: "fra", name: "France", flag: "🇫🇷", group: "A", rank: 2 },
  { id: "ger", name: "Germany", flag: "🇩🇪", group: "B", rank: 13 },
  { id: "esp", name: "Spain", flag: "🇪🇸", group: "C", rank: 3 },
  { id: "eng", name: "England", flag: "🏴󠁧󠁢󠁥󠁮󠁧󠁿", group: "B", rank: 4 },
  { id: "por", name: "Portugal", flag: "🇵🇹", group: "D", rank: 6 },
  { id: "ned", name: "Netherlands", flag: "🇳🇱", group: "B", rank: 7 },
  { id: "ita", name: "Italy", flag: "🇮🇹", group: "D", rank: 9 },
];

const SAMPLE_MARKETS: Market[] = [
  { id: "1", question: "Who wins the 2026 World Cup?", yesPrice: 0.12, noPrice: 0.88, volume: 12500000, endDate: "2026-07-19", category: "Winner" },
  { id: "2", question: "Brazil reaches the final?", yesPrice: 0.45, noPrice: 0.55, volume: 4200000, endDate: "2026-07-10", category: "Finals" },
  { id: "3", question: "USA makes quarterfinals?", yesPrice: 0.38, noPrice: 0.62, volume: 2800000, endDate: "2026-07-03", category: "USA" },
  { id: "4", question: "Argentina successfully defends title?", yesPrice: 0.22, noPrice: 0.78, volume: 8900000, endDate: "2026-07-19", category: "Winner" },
  { id: "5", question: "France wins Group A?", yesPrice: 0.65, noPrice: 0.35, volume: 1200000, endDate: "2026-06-25", category: "Groups" },
  { id: "6", question: "Over 3.5 goals in final?", yesPrice: 0.52, noPrice: 0.48, volume: 3400000, endDate: "2026-07-19", category: "Special" },
  { id: "7", question: "Germany reaches semifinals?", yesPrice: 0.58, noPrice: 0.42, volume: 2100000, endDate: "2026-07-06", category: "Knockout" },
  { id: "8", question: "First goal scored in match 1?", yesPrice: 0.34, noPrice: 0.66, volume: 890000, endDate: "2026-06-11", category: "Special" },
];

function useCountdown(targetDate: string) {
  const [timeLeft, setTimeLeft] = useState({ days: 0, hours: 0, minutes: 0, seconds: 0 });
  useEffect(() => {
    const target = new Date(targetDate).getTime();
    const interval = setInterval(() => {
      const now = Date.now();
      const diff = target - now;
      if (diff > 0) {
        setTimeLeft({
          days: Math.floor(diff / (1000 * 60 * 60 * 24)),
          hours: Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60)),
          minutes: Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60)),
          seconds: Math.floor((diff % (1000 * 60)) / 1000),
        });
      }
    }, 1000);
    return () => clearInterval(interval);
  }, [targetDate]);
  return timeLeft;
}

function MarketCard({ market }: { market: Market }) {
  const formatVolume = (vol: number) => {
    if (vol >= 1000000) return `$${(vol / 1000000).toFixed(1)}M`;
    if (vol >= 1000) return `$${(vol / 1000).toFixed(0)}K`;
    return `$${vol}`;
  };
  return (
    <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }}
      className="bg-card border border-border rounded-xl p-4 hover:border-border-hover transition-all cursor-pointer">
      <div className="flex justify-between items-start mb-3">
        <span className="text-xs font-medium px-2 py-1 rounded-full bg-accent-glow text-accent">{market.category}</span>
        <span className="text-xs text-tertiary">{formatVolume(market.volume)}</span>
      </div>
      <h3 className="text-sm font-medium mb-4 line-clamp-2">{market.question}</h3>
      <div className="flex gap-2">
        <button className="flex-1 py-2 px-3 rounded-lg bg-green-500/10 text-green-400 font-medium text-sm hover:bg-green-500/20 transition-colors">
          YES {(market.yesPrice * 100).toFixed(0)}%
        </button>
        <button className="flex-1 py-2 px-3 rounded-lg bg-red-500/10 text-red-400 font-medium text-sm hover:bg-red-500/20 transition-colors">
          NO {(market.noPrice * 100).toFixed(0)}%
        </button>
      </div>
    </motion.div>
  );
}

function MatchCard({ match }: { match: Match }) {
  const stageColors = {
    group: "bg-accent-glow text-blue-400",
    knockout: "bg-red-500/15 text-red-400",
    final: "bg-yellow-500/15 text-yellow-400",
  };
  return (
    <motion.div initial={{ opacity: 0, scale: 0.95 }} animate={{ opacity: 1, scale: 1 }}
      className="bg-card border border-border rounded-xl p-5 hover:border-border-hover hover:-translate-y-1 transition-all cursor-pointer group">
      <div className="flex justify-between items-center mb-4">
        <span className="text-xs text-tertiary uppercase">{match.date}</span>
        <span className={`text-xs font-semibold px-2 py-1 rounded-full ${stageColors[match.stage]}`}>
          {match.stage === "final" ? "🏆 FINAL" : match.stage === "knockout" ? "🔴 KNOCKOUT" : `Group ${match.group}`}
        </span>
      </div>
      <div className="flex items-center justify-between py-4 border-y border-border">
        <div className="flex-1 text-center">
          <div className="text-2xl mb-2">{match.team1 === "TBD" ? "❓" : "⚽"}</div>
          <div className="font-semibold">{match.team1}</div>
        </div>
        <div className="px-4 text-tertiary font-mono text-sm">VS</div>
        <div className="flex-1 text-center">
          <div className="text-2xl mb-2">{match.team2 === "TBD" ? "❓" : "⚽"}</div>
          <div className="font-semibold">{match.team2}</div>
        </div>
      </div>
      <div className="flex justify-between items-center mt-4 text-sm">
        <span className="text-accent font-medium">{match.time}</span>
        <span className="text-tertiary">{match.venue}</span>
      </div>
    </motion.div>
  );
}

function TeamCard({ team }: { team: Team }) {
  return (
    <motion.div initial={{ opacity: 0, scale: 0.95 }} animate={{ opacity: 1, scale: 1 }}
      className="bg-card border border-border rounded-xl p-4 hover:border-border-hover transition-all">
      <div className="flex items-center gap-3">
        <span className="text-3xl">{team.flag}</span>
        <div>
          <h3 className="font-semibold">{team.name}</h3>
          <span className="text-xs text-tertiary">Group {team.group}</span>
        </div>
      </div>
      {team.rank && (
        <div className="mt-3 pt-3 border-t border-border flex justify-between items-center">
          <span className="text-xs text-tertiary">FIFA Rank</span>
          <span className="text-sm font-mono text-accent">#{team.rank}</span>
        </div>
      )}
    </motion.div>
  );
}

export default function Dashboard() {
  const [activeTab, setActiveTab] = useState<"matches" | "teams" | "markets">("matches");
  const [searchQuery, setSearchQuery] = useState("");
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const countdown = useCountdown("2026-06-11T17:00:00");

  const filteredMatches = useMemo(() => {
    if (!searchQuery) return MATCHES;
    const query = searchQuery.toLowerCase();
    return MATCHES.filter(m => m.team1.toLowerCase().includes(query) || m.team2.toLowerCase().includes(query) || m.venue.toLowerCase().includes(query));
  }, [searchQuery]);

  const filteredTeams = useMemo(() => {
    if (!searchQuery) return TEAMS;
    const query = searchQuery.toLowerCase();
    return TEAMS.filter(t => t.name.toLowerCase().includes(query) || t.group.toLowerCase().includes(query));
  }, [searchQuery]);

  const totalVolume = SAMPLE_MARKETS.reduce((sum, m) => sum + m.volume, 0);

  const tabs = [
    { id: "matches", label: "Matches", icon: Calendar },
    { id: "teams", label: "Teams", icon: Users },
    { id: "markets", label: "Markets", icon: TrendingUp },
  ] as const;

  return (
    <div className="min-h-screen bg-background">
      <header className="border-b border-border sticky top-0 bg-background/80 backdrop-blur-xl z-50">
        <div className="max-w-7xl mx-auto px-4 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-gradient rounded-lg flex items-center justify-center text-lg font-bold">🏆</div>
              <span className="text-xl font-bold hidden sm:block">World Cup <span className="text-gradient">2026</span></span>
            </div>
            <nav className="hidden md:flex items-center gap-1">
              {tabs.map(tab => (
                <button key={tab.id} onClick={() => setActiveTab(tab.id)}
                  className={`flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
                    activeTab === tab.id ? "bg-card text-white" : "text-secondary hover:text-white hover:bg-card/50"
                  }`}>
                  <tab.icon size={16} /> {tab.label}
                </button>
              ))}
            </nav>
            <div className="flex items-center gap-3">
              <button className="flex items-center gap-2 px-4 py-2 bg-gradient text-white rounded-lg text-sm font-medium hover:opacity-90 transition-opacity">
                <Wallet size={16} /><span className="hidden sm:inline">Connect</span>
              </button>
              <button className="md:hidden p-2" onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}>
                {isMobileMenuOpen ? <X size={20} /> : <Menu size={20} />}
              </button>
            </div>
          </div>
          {isMobileMenuOpen && (
            <motion.div initial={{ opacity: 0, height: 0 }} animate={{ opacity: 1, height: "auto" }} className="md:hidden py-4 flex flex-col gap-1">
              {tabs.map(tab => (
                <button key={tab.id} onClick={() => { setActiveTab(tab.id); setIsMobileMenuOpen(false); }}
                  className={`flex items-center gap-2 px-4 py-3 rounded-lg text-sm font-medium ${
                    activeTab === tab.id ? "bg-card text-white" : "text-secondary"
                  }`}>
                  <tab.icon size={16} /> {tab.label}
                </button>
              ))}
            </motion.div>
          )}
        </div>
      </header>

      <main className="max-w-7xl mx-auto px-4 py-8">
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
          <div className="bg-card border border-border rounded-xl p-4 text-center">
            <div className="text-2xl font-bold text-gradient">48</div>
            <div className="text-xs text-secondary">Matches</div>
          </div>
          <div className="bg-card border border-border rounded-xl p-4 text-center">
            <div className="text-2xl font-bold text-gradient">48</div>
            <div className="text-xs text-secondary">Teams</div>
          </div>
          <div className="bg-card border border-border rounded-xl p-4 text-center">
            <div className="text-2xl font-bold text-gradient">3</div>
            <div className="text-xs text-secondary">Countries</div>
          </div>
          <div className="bg-gradient border-0 rounded-xl p-4 text-center">
            <div className="text-2xl font-bold text-white">${(totalVolume / 1000000).toFixed(1)}M</div>
            <div className="text-xs text-white/70">Trading Volume</div>
          </div>
        </div>

        <div className="bg-card border border-border rounded-2xl p-8 mb-8 text-center relative overflow-hidden">
          <div className="absolute top-0 left-0 right-0 h-1 bg-gradient" />
          <h2 className="text-sm text-secondary uppercase tracking-widest mb-6">Tournament Begins In</h2>
          <div className="flex justify-center gap-4 md:gap-6 flex-wrap">
            <div className="bg-background rounded-xl p-4 min-w-[80px]">
              <div className="text-3xl md:text-4xl font-bold font-mono">{countdown.days}</div>
              <div className="text-xs text-tertiary uppercase mt-1">Days</div>
            </div>
            <div className="bg-background rounded-xl p-4 min-w-[80px]">
              <div className="text-3xl md:text-4xl font-bold font-mono">{countdown.hours}</div>
              <div className="text-xs text-tertiary uppercase mt-1">Hours</div>
            </div>
            <div className="bg-background rounded-xl p-4 min-w-[80px]">
              <div className="text-3xl md:text-4xl font-bold font-mono">{countdown.minutes}</div>
              <div className="text-xs text-tertiary uppercase mt-1">Minutes</div>
            </div>
            <div className="bg-background rounded-xl p-4 min-w-[80px]">
              <div className="text-3xl md:text-4xl font-bold font-mono text-accent">{countdown.seconds}</div>
              <div className="text-xs text-tertiary uppercase mt-1">Seconds</div>
            </div>
          </div>
        </div>

        <div className="relative mb-6">
          <Search className="absolute left-4 top-1/2 -translate-y-1/2 text-tertiary" size={20} />
          <input type="text" placeholder={`Search ${activeTab}...`} value={searchQuery} onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full pl-12 pr-4 py-4 bg-card border border-border rounded-xl text-white placeholder:text-tertiary focus:outline-none focus:border-accent focus:ring-2 focus:ring-accent-glow" />
        </div>

        <AnimatePresence mode="wait">
          {activeTab === "matches" && (
            <motion.div key="matches" initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0, y: -20 }}
              className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              {filteredMatches.map((match) => <MatchCard key={match.id} match={match} />)}
            </motion.div>
          )}
          {activeTab === "teams" && (
            <motion.div key="teams" initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0, y: -20 }}
              className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
              {filteredTeams.map((team) => <TeamCard key={team.id} team={team} />)}
            </motion.div>
          )}
          {activeTab === "markets" && (
            <motion.div key="markets" initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0, y: -20 }}>
              <div className="flex items-center gap-2 mb-4 text-sm text-secondary">
                <Activity size={16} className="text-green-400" /> Live Polymarket-style odds
              </div>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                {SAMPLE_MARKETS.map((market) => <MarketCard key={market.id} market={market} />)}
              </div>
            </motion.div>
          )}
        </AnimatePresence>
      </main>
    </div>
  );
}
