import { AlimentSource } from "./AlimentSource";
import { CatalogPresentation } from "./CatalogPresentation";

export interface AlimentCatalog {
    original: AlimentSource;
    aiEnhanced: AlimentSource;
    presentations: Record<string, CatalogPresentation>;
}