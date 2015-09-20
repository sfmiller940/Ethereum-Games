contract Crowdfunding {
    struct CampaignData {
        address recipient;
        uint contributed;
        uint goal;
        uint deadline;
        uint num_contributions;
        mapping(uint => Contribution) contributions;
    };
    struct Contribution {
        address contributor;
        uint amount;
    };

    // Start a new campaign.
    function start(address recipient, uint256 goal, uint256 deadline) returns (uint id) {
        campaigns[nextCampaignId] = CampaignData(recipient, 0, goal, deadline);
        nextCampaignId ++;
        id = nextCampaignId;
    }

    // Contribute to the compaign with id $(campaignId).
    function contribute(uint256 campaignId) {
        var campaign = campaigns[campaignId];
        if (campaign.deadline == 0) // check for non-existing campaign
            return;
        campaign.contributed += transaction.value;
        campaign.contributions[campaign.num_contributions] =
                      Contribution(transaction.sender, transaction.value);
        campaign.num_contributions++;
    }

    // Check whether the funding goal of the campaign with id $(campaignId)
    // has been reached and transfer the money.
    function checkGoalReached(uint256 campaignId) returns (bool reached)
    {
        var campaign = campaigns[campaignId];
        if (campaign.deadline > 0 && campaign.contributed >= campaign.goal) {
            send(campaign.recipient, campaign.contributed);
            // clear storage, we have to do it explicitly for the mapping since
            // it is not possible to enumerate all set keys.
            for (uint i = 0; i < campaign.num_contributions; i++) {
                delete campaign.contributions[i]; // zero out its members
            }
            delete campaign;
            reached = true;
        }
    }

    // Check whether the deadline of the campaign with id $(campaignId) has
    // passed. In that case, return the contributed money and delete the
    // campaign.
    function checkExpired(uint campaignId) returns (bool expired)
    {
        expired = false;
        var campaign = campaigns[campaignId];
        if (campaign.deadline > 0 && block.timestamp > campaign.deadline) {
            // pay out the contributors
            for (uint i = 0; i < campaign.num_contributors; i++) {
                send(campaign.contributions[i].contributor,
                     campaign.contributions[i].amount);
                delete campaign.contributions[i];
            }
            delete campaign;
            expired = true;
        }
    }

    // Return the amount contributed to the campaign with id $(campaignId) by
    // the sender of the transaction.
    function getContributedAmount(uint campaignId) returns (uint amount)
    {
        amount = campaigns[campaignId].contributed;
    }

state:
    uint nextCampaignId;
    mapping(uint256 => CampaignData) campaigns;
};
