import { Test, TestingModule } from '@nestjs/testing';
import { AdventureController } from './adventure.controller';
import { AdventureService } from './adventure.service';
import { Adventure } from './adventure.entity';
import { paginate, Pagination, IPaginationOptions, IPaginationMeta } from 'nestjs-typeorm-paginate';

jest.mock('./adventure.service');

describe('AdventureController', () => {
  let controller: AdventureController;
  let adventureService: AdventureService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [AdventureController],
      providers: [
        {
          provide: AdventureService,
          useValue: adventureService, // Use the mocked instance directly
        },
      ],
    }).compile();

    controller = module.get<AdventureController>(AdventureController);
    adventureService = module.get<AdventureService>(AdventureService);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  it('should get all adventures', async () => {
    const adventures: Adventure[] = [{ id: 1, name: 'Adventure 1', description: 'Description 1' }];

    // Wrap the adventures array in a Pagination object
    const pagination: Pagination<Adventure, IPaginationMeta> = {
        items: adventures,
        links: {},
        meta: { itemCount: adventures.length, totalItems: adventures.length, itemsPerPage: 10, totalPages: 1, currentPage: 1 },
    };

    jest.spyOn(adventureService, 'findAll').mockResolvedValue(pagination);
    expect(await controller.findAll({})).toBe(pagination);
});

  it('should get a single adventure', async () => {
    const adventureId = 1;
    const adventure: Adventure = { id: adventureId, name: 'Adventure 1', description: 'Description 1' };
    jest.spyOn(adventureService, 'getSingleAdventure').mockResolvedValue(adventure);
    expect(await controller.getAdventure(adventureId.toString())).toBe(adventure);
  });

  it('should create a new adventure', async () => {
    const adventureDto = { name: 'New Adventure', description: 'New Description' };
    const createdAdventure: Adventure = { id: 1, ...adventureDto };
    jest.spyOn(adventureService, 'create').mockResolvedValue(createdAdventure);
    expect(await controller.createAdventure(adventureDto)).toBe(createdAdventure);
  });

  it('should update an adventure', async () => {
    const adventureId = 1;
    const adventureDto = { name: 'Updated Adventure', description: 'Updated Description' };
    const updatedAdventure: Adventure = { id: adventureId, ...adventureDto };
    jest.spyOn(adventureService, 'update').mockResolvedValue(updatedAdventure);
    expect(await controller.updateAdventure(adventureId, adventureDto)).toBe(updatedAdventure);
  });

  it('should delete an adventure', async () => {
    const adventureId = 1;
    const deletedAdventure: Adventure = { id: adventureId, name: 'Deleted Adventure', description: 'Deleted Description' };
    jest.spyOn(adventureService, 'deleteAdventure').mockResolvedValue(deletedAdventure);
    expect(await controller.deleteAdventure(adventureId)).toBe(deletedAdventure);
  });
});
