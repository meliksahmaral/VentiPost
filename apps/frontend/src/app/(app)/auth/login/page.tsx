export const dynamic = 'force-dynamic';

import { Login } from '@gitroom/frontend/components/auth/login';
import { Metadata } from 'next';
import { isGeneralServerSide } from '@gitroom/helpers/utils/is.general.server.side';

// Tek merkezden brand adı yönetimi
const BRAND_NAME =
  process.env.NEXT_PUBLIC_APP_NAME ||
  (isGeneralServerSide() ? 'Postiz' : 'Gitroom');

export const metadata: Metadata = {
  title: `${BRAND_NAME} Login`,
  description: '',
};

export default async function Auth() {
  return <Login />;
}
