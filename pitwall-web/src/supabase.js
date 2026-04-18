import { createClient } from "@supabase/supabase-js";

const SUPABASE_URL = "https://kyqjkfohzsvdxfbmceld.supabase.co";
const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt5cWprZm9oenN2ZHhmYm1jZWxkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY0OTYzMTIsImV4cCI6MjA5MjA3MjMxMn0.qJmf9wQNmgRDsHNFdLLjG2FrWz3jjCgse5JPbKqKs_g";

export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);