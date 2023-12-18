import { Test, TestingModule } from '@nestjs/testing';
import { AdventureController } from './adventure.controller';
import { AdventureService } from './adventure.service';
import { Adventure } from './adventure.entity';
import { paginate, Pagination } from 'nestjs-typeorm-paginate';
import { FindOneOptions } from 'typeorm';

jest.mock('./adventure.service');

describe('AdventureController', () => {
  let controller: AdventureController;
  let adventureService: AdventureService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [AdventureController],
      providers: [AdventureService],
    }).compile();

    controller = module.get<AdventureController>(AdventureController);
    adventureService = module.get<AdventureService>(AdventureService);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  it('should get all adventures', async () => {
    const adventures: Adventure[] = [{ id: 1, name: 'Adventure 1', description: 'Description 1' }];

    const pagination: Pagination<Adventure> = {
        items: adventures,
        links: {},
        meta: { itemCount: adventures.length, totalItems: adventures.length, itemsPerPage: 10, totalPages: 1, currentPage: 1 },
    };

    jest.spyOn(adventureService, 'findAll').mockResolvedValue(pagination);

    expect(await controller.findAll({})).toBe(pagination);
});



  it('should create a new adventure', async () => {
    const adventureDto = { name: 'New Adventure', description: 'New Description' };
    const createdAdventure: Adventure = { id: 2, ...adventureDto }; // Use a different ID
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
