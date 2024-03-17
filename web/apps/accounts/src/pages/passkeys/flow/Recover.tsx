import { TwoFactorType } from "@ente/accounts/constants/twofactor";
import RecoverPage from "@ente/accounts/pages/recover";
import { APPS } from "@ente/shared/apps/constants";
import { useRouter } from "next/router";
import { AppContext } from "pages/_app";
import { useContext } from "react";

export default function Recover() {
    const appContext = useContext(AppContext);
    const router = useRouter();
    return (
        <RecoverPage
            appContext={appContext}
            router={router}
            appName={APPS.PHOTOS}
            twoFactorType={TwoFactorType.PASSKEY}
        />
    );
}
