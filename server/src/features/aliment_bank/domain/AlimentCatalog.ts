import { AlimentSource } from "./AlimentSource";
import { CatalogPresentation } from "./CatalogPresentation";

export interface AlimentCatalog {
    original: AlimentSource | undefined;
    ai_enhanced: AlimentSource | undefined;
    presentations: Record<string, CatalogPresentation>;
}