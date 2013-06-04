/**
 * 
 */
package com.cypress.forum.dao;

/**
 * A factory for creating Repo objects.
 * 
 * @author Neyas Anand (neys)
 */
public abstract class RepoFactory {

    /** The Constant ORACLE. */
    public static final int ORACLE = 1;

    /** The Constant MONGO. */
    public static final int MONGO = 2;

    /**
     * Instantiates a new repo factory.
     */
    protected RepoFactory() {
    }

    /**
     * Gets the repo factory.
     * 
     * @param whichFactory
     *            the which factory
     * @return the repo factory
     */
    public static final RepoFactory getRepoFactory(int whichFactory) {
        switch (whichFactory) {
        case ORACLE:
            return null;
        case MONGO:
            return new MongoRepoFactory();
        default:
            return null;
        }
    }
}
